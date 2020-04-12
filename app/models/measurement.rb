class Measurement < ApplicationRecord
  validates :date, presence: true
  validates :value, presence: true
  default_scope { order(date: :desc) }
end
