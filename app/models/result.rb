class Result < ApplicationRecord
  belongs_to :daily
  belongs_to :timing, optional: true

  validates :daily_id,  numericality: { only_integer: true }
  validates :date, presence: true, format: { with: VALID_DATE_REGEX }
  validates :temperature, numericality: { allow_blank: true }
  validates :timing_id, numericality: { only_integer: true, allow_blank: true }
  validates :distance, numericality: { allow_blank: true }
  validates :time_h, numericality: { only_integer: true, allow_blank: true }
  validates :time_m, numericality: { only_integer: true, less_than: 60, allow_blank: true }
  validates :time_s, numericality: { only_integer: true, less_than: 60, allow_blank: true }
  validates :pace_m, numericality: { only_integer: true, less_than: 60, allow_blank: true }
  validates :pace_s, numericality: { only_integer: true, less_than: 60, allow_blank: true }
  validates :place, length: { maximum: 255 }
  validates :shoes, length: { maximum: 255 }
  validates :deleted, presence: true, numericality: { only_integer: true }
end
