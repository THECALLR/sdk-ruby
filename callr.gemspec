Gem::Specification.new do |s|
	s.name                   = 'callr'
	s.version                = '1.1.0'
	s.date                   = '2017-02-15'
	s.summary                = "CALLR SDK"
	s.description            = "Ruby SDK for CALLR API"
	s.authors                = ["Michael JACQUIN", "Vincent MERCIER"]
	s.email                  = 'mj@callr.com'
	s.files                  = ["lib/callr.rb"]
	s.homepage               = 'https://github.com/THECALLR/sdk-ruby'
	s.license                = 'MIT'
	s.required_ruby_version  = '>= 1.8.0'
	s.add_runtime_dependency 'json', '>= 1.8.1'
end
