require 'rails_helper'

RSpec.describe GoalDecorator do
  include ActiveSupport::Testing::TimeHelpers

  describe '#description' do
    it 'describes the goal' do
      goal = build(:goal, value: 72.32, date: '2020-05-02').decorate
      expect(goal.description).to eq('72.3kg by 2nd May')
    end
  end

  describe '#target' do
    context 'with measurements' do
      it 'returns expected value given linear progress between goal points' do
        goal = create(:goal, date: Date.tomorrow, value: 60).decorate
        create(:measurement, goal: goal, date: 2.days.ago, value: 70)
        expect(goal.target).to eq('63.3')
      end
    end

    context 'without measurements' do
      it 'returns ?' do
        expect(build(:goal).decorate.target).to eq('?')
      end
    end
  end

  describe '#target_delta' do
    context 'with measurements' do
      before do
        @goal = create(:goal, date: Date.tomorrow, value: 60).decorate
        create(:measurement, goal: @goal, date: 2.days.ago, value: 70)
      end

      it 'returns delta when on target' do
        create(:measurement, goal: @goal, date: Date.today, value: 63.3)
        expect(@goal.target_delta).to eq('on target')
      end

      it 'returns delta to target when behind' do
        create(:measurement, goal: @goal, date: Date.today, value: 65)
        expect(@goal.target_delta).to eq('1.7 behind')
      end

      it 'returns delta to target when ahead' do
        create(:measurement, goal: @goal, date: Date.today, value: 62)
        expect(@goal.target_delta).to eq('1.3 ahead')
      end
    end

    context 'without measurements' do
      it 'returns ?' do
        expect(build(:goal).decorate.target_delta).to eq('?')
      end
    end
  end

  describe '#daily_goal' do
    it 'returns loss required per day to hit target' do
      goal = create(:goal, date: Date.tomorrow, value: 70).decorate
      create(:measurement, goal: goal, date: 2.days.ago, value: 80)
      expect(goal.daily_goal).to eq('3.33')
    end

    context 'without measurements' do
      it 'returns ?' do
        expect(build(:goal).decorate.daily_goal).to eq('?')
      end
    end
  end

  describe '#current' do
    context 'with measurements' do
      it 'returns latest measurement value' do
        goal = create(:goal)
        create(:measurement, goal: goal, date: Date.yesterday, value: 80)
        create(:measurement, goal: goal, date: Date.today, value: 70)

        expect(goal.decorate.current).to eq(70)
      end
    end

    context 'without measurements' do
      it 'handles missing measurements' do
        expect(build(:goal).decorate.current).to eq('?')
      end
    end
  end

  describe '#to_go' do
    context 'with measurements' do
      it 'returns latest measurement minus goal' do
        goal = create(:goal, :with_measurements).decorate
        expect(goal.to_go).to eq(goal.latest_measurement.value - goal.value)
      end
    end

    context 'without measurements' do
      it 'returns ?' do
        expect(build(:goal).decorate.to_go).to eq('?')
      end
    end
  end

  describe '#projected_value' do
    context 'with measurements' do
      it 'predicts value at goal end date' do
        goal = create(:goal, value: 50, date: Date.today).decorate
        create(:measurement, goal: goal, date: 5.days.ago, value: 80)
        create(:measurement, goal: goal, date: 3.days.ago, value: 70)

        expect(goal.projected_value).to include('55.0')
      end
    end

    context 'with insufficient measurements' do
      it 'returns ? for none' do
        expect(build(:goal).decorate.projected_value).to eq('?')
      end

      it 'returns ? for one' do
        goal = create(:goal, :with_measurements, measurements_count: 1).decorate
        expect(goal.projected_value).to eq('?')
      end
    end
  end

  describe '#projected_date' do
    context 'with_measurements' do
      it 'predicts date at goal end value' do
        travel_to '2020-4-10 12:00'

        goal = create(:goal, value: 50, date: Date.today).decorate
        create(:measurement, goal: goal, date: 5.days.ago, value: 80)
        create(:measurement, goal: goal, date: 3.days.ago, value: 70)

        expect(goal.projected_date).to eq('50.0kg on 11th April')
      end
    end

    context 'with insufficient measurements' do
      it 'returns ? for none' do
        expect(build(:goal).decorate.projected_date).to eq('?')
      end

      it 'returns ? for one' do
        goal = create(:goal, :with_measurements, measurements_count: 1).decorate
        expect(goal.projected_date).to eq('?')
      end
    end
  end

  describe '#chart_definition' do
    it 'returns json chart data' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.yesterday, value: 60)
      create(:measurement, goal: goal, date: Date.today, value: 55)

      expect(goal.decorate.chart_definition).to include_json(
        type: 'scatter',
        data: {
          datasets: [
            {
              data: [
                { x: Date.today.strftime('%Y-%m-%d'), y: '55.0' },
                { x: Date.yesterday.strftime('%Y-%m-%d'), y: '60.0' }
              ]
            }
          ]
        }
      )
    end
  end
end
