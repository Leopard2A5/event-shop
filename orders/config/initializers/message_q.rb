require 'bunny'

module RabbitMQInitializer

  def self.registered(app)
    rabbitmq_hostname = ENV['RABBITMQ_HOSTNAME'] || 'localhost'
    $QUEUE_MANAGER = QueueManager.new(rabbitmq_hostname)

    $QUEUE_MANAGER.listen('orders_credited') do |body|
      order = Order.find(body.to_i)
      order.status = 'CREDITED'
      order.save
    end

    $QUEUE_MANAGER.listen('orders_declined') do |body|
      order = Order.find(body.to_i)
      order.status = 'DECLINED'
      order.save
    end
  end

end
