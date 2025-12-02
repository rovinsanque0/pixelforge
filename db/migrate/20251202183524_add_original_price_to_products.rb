class AddOriginalPriceToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :original_price, :decimal, precision: 8, scale: 2
  end
end
