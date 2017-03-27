require 'bunny'

module RabbitMQInitializer

  def self.registered(app)
    # $MSG_Q = self.connect()
    # $MSG_Q_CHANNEL = $MSG_Q.create_channel
    # $MSG_Q_QUEUE = $MSG_Q_CHANNEL.queue('orders_created')
  end

  def self.connect()
    conn = Bunny.new(hostname: 'rabbitmq')
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

    conn
  end

end
