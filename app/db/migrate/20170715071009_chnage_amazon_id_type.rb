class ChnageAmazonIdType < ActiveRecord::Migration[5.1]
  def change
  	change_column :products, :amazon_product_id, :string
  end
end
