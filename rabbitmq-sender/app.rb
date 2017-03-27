#!/usr/bin/env ruby

require 'bunny'
require 'rest-client'

def connect(conn)
  attempts = 5
  begin
    conn.start
  rescue Bunny::TCPConnectionFailedForAllHosts => e
    attempts -= 1
    if attempts > 0
      sleep(3)
      retry
    else
      raise e
    end
  end
end

conn = Bunny.new(:hostname => 'rabbitmq')
connect(conn)

ch = conn.create_channel
q = ch.queue('hello')

while true
  response = RestClient.get('http://counter:4567/getAndIncrement')
  i = response.body.to_i
  payload = "payload-#{i}"
  ch.default_exchange.publish(payload, :routing_key => q.name)
  STDERR.puts "Sent #{payload}"
  sleep 3
end
