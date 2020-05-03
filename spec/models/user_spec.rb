require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:measurements).dependent(:destroy) }
    it { is_expected.to have_one(:goal).dependent(:destroy) }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '.latest_measurement' do
    it 'returns the latest measurement' do
      user = create(:user)
      goal = create(:goal, user: user)
      create(:measurement, user: user, goal: goal, date: Date.today - 2.days)
      latest = create(:measurement, user: user, goal: goal, date: Date.today)
      create(:measurement, user: user, goal: goal, date: Date.today - 1.day)

      expect(user.latest_measurement).to eq(latest)
    end
  end

  describe '.first_measurement' do
    it 'returns the first measurement' do
      user = create(:user)
      goal = create(:goal, user: user)
      first = create(:measurement, user: user, goal: goal, date: Date.today - 2.days)
      create(:measurement, user: user, goal: goal, date: Date.today)
      create(:measurement, user: user, goal: goal, date: Date.today - 1.day)

      expect(user.first_measurement).to eq(first)
    end
  end
end
