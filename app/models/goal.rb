class Goal < ApplicationRecord
  belongs_to :user
  has_many :measurements

  validates :user_id, presence: true
  validates :date, presence: true
  validates :value, presence: true
end
