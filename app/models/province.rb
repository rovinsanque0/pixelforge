class Province < ApplicationRecord
  has_many :users
  has_many :orders

  validates :name, presence: true
  validates :gst, :pst, :hst, numericality: true
end
