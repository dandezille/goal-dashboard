class Goal < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :end_date, presence: true
  validates :end_value, presence: true
end
