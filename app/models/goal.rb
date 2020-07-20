class Goal < ApplicationRecord
  belongs_to :user
  has_many :measurements, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true
  validates :units, presence: true
  validates :date, presence: true
  validates :target, presence: true

  scope :active, -> { where('date >= ?', Date.today) }
  scope :complete, -> { where.not(id: active) }

  def calculations
    @calculations ||= GoalCalculator.new(self)
  end
end
