class Measurement < ApplicationRecord
  belongs_to :goal

  validates :goal_id, presence: true
  validates :date, presence: true
  validates :value, presence: true

  default_scope { order(date: :asc) }
end
