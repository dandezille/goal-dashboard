class Measurement < ApplicationRecord
  belongs_to :user
  validates :date, presence: true
  validates :value, presence: true
  default_scope { order(date: :desc) }
end
