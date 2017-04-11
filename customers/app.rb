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
q_orders_created = ch.queue('orders_created', durable: true)
q_orders_credited = ch.queue('orders_credited', durable: true)
q_orders_declined = ch.queue('orders_declined', durable: true)

STDERR.puts "Listening on queue orders_created"
q_orders_created.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
  STDERR.puts "Received #{body}"
  body = JSON.parse(body)
  if body['amount'].to_f < 50.0
    STDERR.puts "Order #{body['id']} credited"
    ch.default_exchange.publish(body['id'].to_json, :routing_key => q_orders_credited.name)
  else
    STDERR.puts "Order #{body['id']} declined"
    ch.default_exchange.publish(body['id'].to_json, :routing_key => q_orders_declined.name)
  end
  ch.ack(delivery_info.delivery_tag)
end
