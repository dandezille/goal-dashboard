class Goal < ApplicationRecord
  belongs_to :user
  has_many :measurements, dependent: :destroy

  validates :user_id, presence: true
  validates :date, presence: true
  validates :value, presence: true

  def latest_measurement
    measurements.order(:date).first
  end

  def first_measurement
    measurements.order(:date).last
  end
end
