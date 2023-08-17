class SleepPattern < ApplicationRecord
  has_many :dailies, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :sort, presence: true, numericality: { only_integer: true }
end
