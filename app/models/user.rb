class User < ApplicationRecord
  include Clearance::User
  has_many :measurements, dependent: :destroy
  has_one :goal, dependent: :destroy

  def latest_measurement
    goal.measurements.order(:date).first
  end

  def first_measurement
    goal.measurements.order(:date).last
  end
end
