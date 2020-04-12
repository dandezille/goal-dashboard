class Measurement < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :value, presence: true

  default_scope { order(date: :desc) }
end
