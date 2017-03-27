class Order < ActiveRecord::Base
  validates :customer_id, presence: true, length: { minimum: 1 }
  validates :amount, numericality: { greater_than: 0.0 }
end
