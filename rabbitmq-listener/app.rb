#!/usr/bin/env ruby

require 'bunny'

conn = Bunny.new(:hostname => 'rabbitmq')
conn.start

ch = conn.create_channel
q = ch.queue('hello')

while true
  ch.default_exchange.publish('hello world', :routing_key => q.name)
  puts "Sent hello world"
  sleep 3
end
