class User < ApplicationRecord
  include Clearance::User
  has_many(:measurements)
  has_one(:goal)
end
