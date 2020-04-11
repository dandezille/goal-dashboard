class Measurement < ApplicationRecord
  validates :date, presence: true
  validates :value, presence: true
end
