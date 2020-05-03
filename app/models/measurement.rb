class Measurement < ApplicationRecord
  belongs_to :user
  belongs_to :goal

  validates :user_id, presence: true
  validates :date, presence: true
  validates :value, presence: true

  default_scope { order(date: :desc) }
end
