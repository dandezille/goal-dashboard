class User < ApplicationRecord
  include Clearance::User
  has_many :measurements, dependent: :destroy
  has_one :goal, dependent: :destroy
end
