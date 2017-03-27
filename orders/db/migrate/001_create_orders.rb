class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :customer_id
      t.decimal :amount
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :orders
  end
end
