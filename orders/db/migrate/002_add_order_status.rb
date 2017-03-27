require './models/order.rb'

class AddOrderStatus < ActiveRecord::Migration[5.0]
  def self.up
    change_table :orders do |t|
      t.string :status
    end

    Order.find_each do |order|
      order.status = 'COMPLETED'
      order.save!
    end

    change_column_null :orders, :status, false
  end

  def self.down
    change_table :orders do |t|
      t.remove :status
    end
  end
end
