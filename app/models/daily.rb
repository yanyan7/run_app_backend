class Daily < ApplicationRecord
  belongs_to :sleep_pattern, optional: true
  has_many :results, dependent: :destroy

  validates :date, presence: true, format: { with: VALID_DATE_REGEX }
  validates :sleep_pattern_id,  numericality: { only_integer: true, allow_blank: true }
  validates :weight, numericality: { allow_blank: true }
  validates :deleted, presence: true, numericality: { only_integer: true }
end
