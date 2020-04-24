class User < ApplicationRecord
  include Clearance::User
  has_many(:measurements)
  has_one(:goal)

  def latest_measurement
    measurements.order(:date).first
  end

  def first_measurement
    measurements.order(:date).last
  end
end
