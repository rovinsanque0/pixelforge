class AddSaleFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sale_price, :decimal, precision: 8, scale: 2

    # Only add on_sale if it does NOT exist
    unless column_exists?(:products, :on_sale)
      add_column :products, :on_sale, :boolean, default: false
    end
  end
end
