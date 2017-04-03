class Order < ActiveRecord::Base
  STATES = %w[
    CREATED
    TO_BE_SHIPPED
    COMPLETED
  ]

  validates :customer_id, presence: true, length: { minimum: 1 }
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :status, presence: true, inclusion: { in: STATES }

  after_initialize :init
  after_create :notify_order_created

  def init
    self.status = 'CREATED'
  end

  def notify_order_created
    puts "publishing order creation event"
    $QUEUE_MANAGER.send('orders_created', self.to_json)
  end

end
