class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.string :status
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :gst_amount, precision: 10, scale: 2
      t.decimal :pst_amount, precision: 10, scale: 2
      t.decimal :hst_amount, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :stripe_payment_id

      t.timestamps
    end
  end
end
