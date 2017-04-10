class Order < ActiveRecord::Base
  STATES = %w[
    CREATED
    CREDITED
    COMPLETED
    DECLINED
  ]

  validates :customer_id, presence: true, length: { minimum: 1 }
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :status, presence: true, inclusion: { in: STATES }

  after_initialize :init
  after_save :notify_order_changed

  def init
    self.status = 'CREATED'
  end

  def notify_order_changed
    if self.status != self.status_was
      new_state = self.status.downcase
      STDOUT.puts "publishing state change event for order #{self.id}: '#{self.status_was}' -> '#{self.status}'"
      $QUEUE_MANAGER.send("orders_#{new_state}", self.to_json)
    end
  end

end
