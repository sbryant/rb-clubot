rb-clubot: Simple ruby bindings for clubot.
===========================================

* By Sean Bryant
* https://github.com/sbryant/rb-clubot

Description
-----------
rb-clubot is a simple Client interface for interacting with clubot.
See [Clubot](https://github.com/hackinggibsons/clubot) for more information on running a clubot.

Installation
------------
If you're using bundler just add the gem to your Gemfile:

```ruby
gem 'clubot', :git => "https://github.com/sbryant/rb-clubot"
```

I should have this submitted to rubygems when clubot is more complete.


Usage:
------
Using clubot is incredibly easy and the easiest way to understand clubot 
is to see an example of using clubot.

```ruby
require 'clubot'

client = Clubot::Client.new
client.connect

# Make a blocking request
client.request "type" => "nick" do |data|
  puts "Got data: #{data}"
end

# Poll for IRC broadcasts
loop do
  ins, out, err = ZMQ.select([client.sub_sock])
  ins.each do |i|
    header = i.recv
    json = i.recv

    puts "Got Header #{header}"
    puts "Got json   #{json}"
  end
end
```

Contribute
----------
Just fork and send a pull requests.




