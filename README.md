sdk-ruby
========

SDK in Ruby for THECALLR API

## Quick start
Install via Rubygems

    gem install thecallr

Or get sources from Github

## Initialize your code

Gem

```ruby
require 'thecallr'
```

Source

```ruby
load 'lib/thecallr.rb'
```

## Basic Example
See full example in [samples/quickstart.rb](samples/quickstart.rb)

```ruby
# Set your credentials
thecallr = THECALLR::Api.new("login", "password")

# 1. "call" method: each parameter of the method as an argument
thecallr.call("sms.send", "THECALLR", "+33123456789", "Hello, world", {
	:flash_message => false
})

# 2. "send" method: parameter of the method is an array
my_array = ["THECALLR", "+33123456789", "Hello, world", {
	:flash_message => false
}]
thecallr.send("sms.send", my_array)
```

## Exception Management

```ruby
begin
	# Set your credentials
	thecallr = THECALLR::Api.new("login", "password")

	# This will raise an exception
	thecallr.call("sms.send", "THECALLR")

# Exceptions handler
rescue THECALLR::ThecallrException, THECALLR::ThecallrLocalException => e
	puts "ERROR: #{e.code}"
	puts "MESSAGE: #{e.msg}"
	puts "DATA: ", e.data
end
```
