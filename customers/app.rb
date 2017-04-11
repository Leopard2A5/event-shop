#!/usr/bin/env ruby

require 'json'
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

rabbitmq_hostname = ENV['RABBITMQ_HOSTNAME'] || 'localhost'
conn = Bunny.new(:hostname => rabbitmq_hostname)
connect(conn)

ch = conn.create_channel

ch.fanout("orders_created")
q_orders_created = ch.queue('customers:orders_created', durable: true)
q_orders_created.bind("orders_created")

x_credited = ch.fanout("orders_credited")
x_declined = ch.fanout("orders_declined")

STDERR.puts "Listening on exchange orders_created"
q_orders_created.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
  STDERR.puts "Received #{body}"
  body = JSON.parse(body)
  if body['amount'].to_f < 50.0
    STDERR.puts "Order #{body['id']} credited"
    x_credited.publish(body['id'].to_json)
  else
    STDERR.puts "Order #{body['id']} declined"
    x_declined.publish(body['id'].to_json)
  end
  ch.ack(delivery_info.delivery_tag)
end
