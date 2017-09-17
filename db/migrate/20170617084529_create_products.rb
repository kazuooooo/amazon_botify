class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, unique: true
      t.integer :amazon_product_id,  null: false, unique: true, limit: 8
    end
  end
end
