class User < ApplicationRecord
  include Clearance::User
  has_many :measurements, dependent: :destroy
  has_one :goal, dependent: :destroy

  def latest_measurement
    return nil unless goal
    goal.measurements.order(:date).first
  end

  def first_measurement
    return nil unless goal
    goal.measurements.order(:date).last
  end
end
