class Order < ActiveRecord::Base
  after_initialize :init

  STATES = %w[
    CREATED
    TO_BE_SHIPPED
    COMPLETED
  ]

  def init
    self.status = 'CREATED'
  end

  validates :customer_id, presence: true, length: { minimum: 1 }
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :status, presence: true, inclusion: { in: STATES }
end
