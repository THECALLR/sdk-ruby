require 'thecallr'

begin
	## initialize instance THECALLR::Api
	# set your credentials or an Exception will raise
	thecallr = THECALLR::Api.new("login", "password")

	## an optional third parameter let you add options like proxy support
	# proxy must be in url standard format
	# http[s]://user:password@host:port
	# http[s]://host:port
	# http[s]://host

	# options = {
	# 	:proxy => "https://foo:bar@example.com:8080"
	# }
	# thecallr = THECALLR::Thecallr.new("login", "password", options)


	## Basic example
	# 1. "call" method: each parameter of the method as an argument
	thecallr.call("sms.send", "THECALLR", "+33123456789", "Hello, world", {
		:flash_message => false
	})

	# 2. "send" method: parameter of the method is an array
	my_array = ["THECALLR", "+33123456789", "Hello, world", {
		:flash_message => false
	}]
	thecallr.send("sms.send", my_array)


	# If you don't pass the correct number of parameter for a method an Exception will raise
	thecallr.call("sms.send", "THECALLR")

	# Exception will also raise if there is any HTTP error

# Exceptions handler
rescue THECALLR::ThecallrException, THECALLR::ThecallrLocalException => e
	puts "ERROR: #{e.code}"
	puts "MESSAGE: #{e.msg}"
	puts "DATA: ", e.data
end
