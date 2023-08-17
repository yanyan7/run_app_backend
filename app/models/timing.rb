class Timing < ApplicationRecord
  has_many :results, dependent: :destroy

  validates :name, length: { maximum: 255 }
  validates :sort,  numericality: { only_integer: true }
end
