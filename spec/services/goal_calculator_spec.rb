require 'rails_helper'

RSpec.describe GoalCalculator do
  let(:goal) { create(:goal, date: Date.tomorrow, value: 70) }
  let(:calcs) { GoalCalculator.new(goal) }

  context 'without measurements' do
    it do
      expect { calcs.target }.to raise_error(
        GoalCalculatorError,
        '#target requires measurements'
      )
    end

    it do
      expect { calcs.target_delta }.to raise_error(
        GoalCalculatorError,
        '#target_delta requires measurements'
      )
    end

    it do
      expect { calcs.to_go }.to raise_error(
        GoalCalculatorError,
        '#to_go requires measurements'
      )
    end

    it do
      expect { calcs.daily_goal }.to raise_error(
        GoalCalculatorError,
        '#daily_goal requires measurements'
      )
    end

    it do
      expect { calcs.daily_historic }.to raise_error(
        GoalCalculatorError,
        '#daily_historic requires measurements'
      )
    end

    it do
      expect { calcs.latest_date_delta }.to raise_error(
        GoalCalculatorError,
        '#latest_date_delta requires measurements'
      )
    end

    it do
      expect { calcs.predict_value_at(Date.tomorrow) }.to raise_error(
        GoalCalculatorError,
        '#predict_value_at requires measurements'
      )
    end

    it do
      expect { calcs.predict_date_for(70) }.to raise_error(
        GoalCalculatorError,
        '#predict_date_for requires measurements'
      )
    end
  end

  context 'with measurements' do
    before do
      create(:measurement, goal: goal, date: Date.today, value: 76.2)
      create(:measurement, goal: goal, date: Date.yesterday, value: 80)
    end

    describe '#target' do
      it 'returns target value for today given linear progression from first measurement to goal' do
        expect(calcs.target).to eq(75)
      end
    end

    describe '#target_delta' do
      it 'returns delta between todays target and measurement' do
        expect(calcs.target_delta).to eq(1.2)
      end
    end

    describe '#to_go' do
      it 'returns delta between goal and todays measurement' do
        expect(calcs.to_go).to eq(6.2)
      end
    end

    describe '#daily_goal' do
      it 'returns required daily loss to achieve goal given todays measurement' do
        expect(calcs.daily_goal).to eq(6.2)
      end
    end

    describe '#daily_historic' do
      it 'returns historic loss rate' do
        expect(calcs.daily_historic).to eq(3.8)
      end
    end

    describe '#latest_date_delta' do
      include ActiveSupport::Testing::TimeHelpers

      it 'returns days between today and last measurement' do
        travel_to Date.tomorrow
        expect(calcs.latest_date_delta).to eq(1)
      end
    end

    describe '#predict_value_at' do
      it 'returns expected value at given date' do
        expect(calcs.predict_value_at(Date.tomorrow)).to be_within(0.01).of(
          72.4
        )
      end
    end

    describe '#predict_date_for' do
      it 'returns expected date for given value' do
        expect(calcs.predict_date_for(70)).to eq(2.days.since.to_date)
      end
    end
  end
end
