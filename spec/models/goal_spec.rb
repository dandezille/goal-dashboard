require 'rails_helper'

RSpec.describe Goal do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:measurements).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe '.latest_measurement' do
    it 'returns the latest measurement' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.today - 2.days)
      latest = create(:measurement, goal: goal, date: Date.today)
      create(:measurement, goal: goal, date: Date.today - 1.day)

      expect(goal.latest_measurement).to eq(latest)
    end
  end

  describe '.first_measurement' do
    it 'returns the first measurement' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.today)
      first = create(:measurement, goal: goal, date: Date.today - 2.days)
      create(:measurement, goal: goal, date: Date.today - 1.day)

      expect(goal.first_measurement).to eq(first)
    end
  end

  describe '#calculations' do
    it 'returns a calculator object' do
      goal = create(:goal)
      expect(goal.calculations).to be_a(GoalCalculator)
    end
  end
end
