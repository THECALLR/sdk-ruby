###
# THECALLR webservice communication library
###

require 'net/https'
require 'uri'
require 'json'

module THECALLR
	class Api
		@login = nil
		@password = nil
		@proxy = nil
		@headers = {
			"Expect" => "",
			"Content-Type" => "application/json-rpc; charset=utf-8"
		}

		API_URL = "https://api.thecallr.com/"

		###
		# Initialization
		# @param string login
		# @param string password
		###
		def initialize(login, password, options = nil)
			@login = login
			@password = password
			set_options(options)
		end


		public
		def set_options(options)
			if options.is_a?(Hash)
				options = symbolize_keys(options)
				set_proxy(options[:proxy]) if options.has_key?(:proxy)
			end
		end

		def set_proxy(proxy)
			if proxy.is_a?(String)
				@proxy = URI.parse(proxy)
			else
				raise ThecallrLocalException.new("PROXY_NOT_STRING", 1)
			end
		end

		###
		# Send a request to THECALLR webservice
		###
		def call(method, *params)
			send(method, params)
		end

		###
		# Send a request to THECALLR webservice
		###
		def send(method, params = [], id = nil)
			check_auth()

			json = {
				:id => id.nil? || id.is_a?(Integer) == false ? rand(999 - 100) + 100 : id,
				:jsonrpc => "2.0",
				:method => method,
				:params => params.is_a?(Array) ? params : []
			}.to_json

			uri = URI.parse(API_URL)
			http = http_or_http_proxy(uri)

			req = Net::HTTP::Post.new(uri.request_uri, @headers)
			req.basic_auth(@login, @password)

			begin
				res = http.request(req, json)
				if res.code.to_i != 200
					raise ThecallrException.new("HTTP_CODE_ERROR", -1, {:http_code => res.code.to_i, :http_message => res.message})
				end
				return parse_response(res)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ETIMEDOUT, Errno::ECONNREFUSED,
					Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
				raise ThecallrException.new("HTTP_EXCEPTION", -2, {:exception => e})
			end
		end


		private
		def symbolize_keys(hash)
			res = {}
			hash.map do |k,v|
				res[k.to_sym] = v.is_a?(Hash) ? symbolize_keys(v) : v
			end
			return res
		end

		def check_auth
			if @login.nil? || @password.nil? || @login.length == 0 || @password.length == 0
				raise ThecallrLocalException.new("CREDENTIALS_NOT_SET", 1)
			end
		end

		def http_or_http_proxy(uri)
			if not @proxy.nil?
				http = Net::HTTP::Proxy(
					@proxy.host,
					@proxy.port,
					@proxy.user,
					@proxy.password
				).new(uri.host, uri.port)
			else
				http = Net::HTTP.new(uri.host, uri.port)
			end

			http.use_ssl = uri.scheme == "https"
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			http.open_timeout = 10
			http.read_timeout = 10

			return http
		end

		###
		# Response analysis
		###
		def parse_response(res)
			begin
				data = JSON.parse(res.body)
				if data.nil? == false && data.has_key?("result") && data["result"].nil? == false
					return data["result"]
				elsif data.nil? == false && data.has_key?("error") && data["error"].nil? == false
					raise ThecallrException.new(data["error"]["message"], data["error"]["code"], nil)
				else
					raise ThecallrException.new("INVALID_RESPONSE", -3, {:response => res.body})
				end
			rescue JSON::ParserError
				raise ThecallrException.new("INVALID_RESPONSE", -3, {:response => res.body})
			end
		end
	end

	class ThecallrException < Exception
		attr_reader :msg
		attr_reader :code
		attr_reader :data

		def initialize(msg, code = 0, data = nil)
			@msg = msg
			@code = code
			@data = data
		end
	end

	class ThecallrLocalException < ThecallrException; end
end
