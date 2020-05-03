require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_one(:goal).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '.latest_measurement' do
    it 'returns the latest measurement' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.today - 2.days)
      latest = create(:measurement, goal: goal, date: Date.today)
      create(:measurement, goal: goal, date: Date.today - 1.day)

      expect(goal.user.latest_measurement).to eq(latest)
    end
  end

  describe '.first_measurement' do
    it 'returns the first measurement' do
      goal = create(:goal)
      first = create(:measurement, goal: goal, date: Date.today - 2.days)
      create(:measurement, goal: goal, date: Date.today)
      create(:measurement, goal: goal, date: Date.today - 1.day)

      expect(goal.user.first_measurement).to eq(first)
    end
  end
end
