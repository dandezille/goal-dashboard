class User < ApplicationRecord
  include Clearance::User
  has_many :measurements, dependent: :destroy
  has_many :goals, dependent: :destroy
end
