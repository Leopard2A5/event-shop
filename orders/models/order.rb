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

  after_save :notify_order_changed

  def notify_order_changed
    # only send messages about state changes
    if self.status != self.status_was
      case self.status
      when 'CREATED'
        STDOUT.puts "publishing state change event for order #{self.id}: '#{self.status_was}' -> '#{self.status}'"
        $QUEUE_MANAGER.send(self.to_json)
      end
    end
  end

end
