class Goal < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :value, presence: true
end
