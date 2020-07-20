require 'rails_helper'

RSpec.describe Goal do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:measurements).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:units) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:target) }
  end

  context 'active/complete scope' do
    let!(:active) { create(:goal, date: Date.today) }
    let!(:complete) { create(:goal, date: Date.yesterday) }

    describe '#active' do
      it { expect(Goal.active).to eq([active]) }
    end

    describe '#complete' do
      it { expect(Goal.complete).to eq([complete]) }
    end
  end

  describe '#calculations' do
    it 'returns a calculator object' do
      goal = create(:goal)
      expect(goal.calculations).to be_a(GoalCalculator)
    end
  end

  describe '#measurements_by_week' do
    let(:goal) { create(:goal) }
    let(:start_date) { Date.today.next_week.next_occurring(:tuesday) }
    let!(:first) { create(:measurement, date: start_date, goal: goal) }
    let!(:second) { create(:measurement, date: start_date + 2.days, goal: goal) }
    let!(:third) { create(:measurement, date: start_date + 1.week, goal: goal) }

    it 'returns measurements by week' do
      expect(goal.measurements_by_week).to eq(
        [['', first.value.to_s, '', second.value.to_s, '', '', ''], 
         ['', third.value.to_s, '', '', '', '', '']]
      )
    end

    context 'with no measurements' do
      it 'returns []' do
        expect(create(:goal).measurements_by_week).to eq([])
      end
    end
  end
end
