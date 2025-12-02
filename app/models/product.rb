class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy

  # Active Storage image
  has_one_attached :image

  # Validations
  validates :name, presence: true
  validates :original_price, numericality: { greater_than_or_equal_to: 0 }
  validates :sale_price, numericality: true, allow_nil: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
