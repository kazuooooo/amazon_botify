class CreateOrders < ActiveRecord::Migration[5.1]
  create_table :orders do |t|
    t.integer :product_id, null: false
    t.datetime :ordered_at,  null: false
  end
end
