require 'bunny'

module RabbitMQInitializer

  def self.registered(app)
    $QUEUE_MANAGER = QueueManager.new

    $QUEUE_MANAGER.listen('orders_credited') do |body|
      puts "RECEIVED order credited: #{body}"
    end

    $QUEUE_MANAGER.listen('orders_declined') do |body|
      puts "RECEIVED order declined: #{body}"
    end
  end

end
