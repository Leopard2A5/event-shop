#!/usr/bin/env ruby

require 'bunny'

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

q.subscribe(:block => true) do |delivery_info, properties, body|
  STDERR.puts "Received #{body}"
end
