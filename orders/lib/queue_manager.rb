require 'workers'
require 'bunny'

class QueueManager

  def initialize(hostname = 'localhost')
    @conn = Bunny.new(hostname: hostname)

    attempts = 5
    begin
      @conn.start
    rescue Bunny::TCPConnectionFailedForAllHosts => e
      attempts -= 1
      if attempts > 0
        sleep 3
        retry
      else
        raise e
      end
    end

    @ch = @conn.create_channel
    @exchange = @ch.fanout("orders_created")

    @pool = Workers::Pool.new
    @listens = Hash.new
  end

  def close
    @conn.close
    @pool.dispose(10)
  end

  def send(body)
    @exchange.publish(body)
  end

  def listen(queue_name, &block)
    raise "no no" if @listens[queue_name]
    @listens[queue_name] = true

    @pool.perform do
      puts "Listening to #{queue_name}"
      q = @ch.queue("orders:#{queue_name}", durable: true)
      q.bind(queue_name)

      q.subscribe(manual_ack: true, block: true) do |delivery, properties, body|
        STDERR.puts "RECEIVED ON #{queue_name}: #{body}"
        block.call(body)
        @ch.ack(delivery.delivery_tag)
      end
    end
  end

end
