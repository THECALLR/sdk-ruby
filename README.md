sdk-ruby
========

SDK in Ruby for CALLR API

## Quick start
Install via Rubygems

    gem install callr

Or get sources from Github

## Initialize your code

Gem

```ruby
require 'callr'
api = CALLR::Api.new

# login + password auth
api.set_auth(CALLR::LoginPasswordAuth.new('login', 'password')

# or for a api-key auth
api.set_auth(CALLR::ApiKeyAuth.new('apiKey')
```

Source

```ruby
load 'lib/callr.rb'

# login + password auth
api.set_auth(CALLR::LoginPasswordAuth.new('login', 'password')

# or for a api-key auth
api.set_auth(CALLR::ApiKeyAuth.new('apiKey')
```

Note that for the next examples, we will consider you are using the login + password auth

## Exception management

```ruby
begin
  api = CALLR::Api.new
  api.set_auth(CALLR::LoginPasswordAuth.new('login', 'password')

  api.call('sms.send', 'SMS')
rescue CALLR::CallrException, CALLR::CallrLocalException => e
  puts "ERROR: #{e.code}"
  puts "MESSAGE: #{e.msg}"
  puts "DATA: ", e.data
end
```

## login as :
```ruby
api.set_auth(auth = CALLR::LoginPasswordAuth.new('login', 'password')

auth.log_as('user', 'foo') # login as user foo
auth.log_as('account', 'foo') # login as account foo
auth.log_as(nil, nil) # Remove login-as
```

## making a call to the api
```
api.call('api method', 'param 1', 'param 2', ...)
```

Check our API documentation for a list of methods, parameters, ... : https://www.callr.com/docs/
