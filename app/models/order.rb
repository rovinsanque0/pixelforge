class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :province
  has_many :order_items, dependent: :destroy

  STATUSES = %w[new paid shipped paid-shipped].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :subtotal, :gst_amount, :pst_amount, :hst_amount, :total,
            numericality: true
end
