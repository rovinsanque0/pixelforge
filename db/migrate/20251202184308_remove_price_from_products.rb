class RemovePriceFromProducts < ActiveRecord::Migration[7.2]
def change
  remove_column :products, :price, :decimal
end

end
