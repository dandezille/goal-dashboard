require 'rails_helper'

RSpec.describe UserStatsDecorator do
  context '#new_measurement' do
    it 'returns a new measurement' do
      user = build(:user)
      measurement = decorate(user).new_measurement
      expect(measurement).to be_instance_of(Measurement)
      expect(measurement).to be_new_record
    end
  end

  context '#new_goal' do
    it 'returns a new goal' do
      user = build(:user)
      goal = decorate(user).new_goal
      expect(goal).to be_instance_of(Goal)
      expect(goal).to be_new_record
    end
  end

  context '#goal' do
    it 'returns the user goal' do
      user = build(:user, :with_goal)
      goal = decorate(user).goal
      expect(goal).to include('%.1f' % user.goal.value)
      expect(goal).to include(format_date(user.goal.date))
    end

    it 'handles missing goal' do
      stats = decorate(build(:user))
      expect(stats.goal).to eq('No goal set')
    end
  end

  context '#target' do
    it 'returns expected value given linear progress between goal points' do
      goal = create(:goal, date: Date.tomorrow, value: 60)
      create(:measurement, goal: goal, date: 2.days.ago, value: 70)

      stats = decorate(goal.user)
      expect(stats.target).to eq('63.3')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.target).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.target).to eq('?')
    end
  end

  context '#target_delta' do
    context 'with measurements and goal' do
      before do
        @goal = create(:goal, date: Date.tomorrow, value: 60)
        create(:measurement, goal: @goal, date: 2.days.ago, value: 70)
      end

      it 'returns delta when on target' do
        create(:measurement, goal: @goal, date: Date.today, value: 63.3)
        stats = decorate(@goal.user)
        expect(stats.target_delta).to eq('on target')
      end

      it 'returns delta to target when behind' do
        create(:measurement, goal: @goal, date: Date.today, value: 65)
        stats = decorate(@goal.user)
        expect(stats.target_delta).to eq('1.7 behind')
      end

      it 'returns delta to target when ahead' do
        create(:measurement, goal: @goal, date: Date.today, value: 62)
        stats = decorate(@goal.user)
        expect(stats.target_delta).to eq('1.3 ahead')
      end
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.target_delta).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.target_delta).to eq('?')
    end
  end

  context '#daily_goal' do
    it 'returns loss required per day to hit target' do
      goal = create(:goal, date: Date.tomorrow, value: 70)
      create(:measurement, goal: goal, date: 2.days.ago, value: 80)

      stats = decorate(goal.user)
      expect(stats.daily_goal).to eq('3.33')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.daily_goal).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.daily_goal).to eq('?')
    end
  end

  context '#current' do
    it 'returns latest measurement value' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.yesterday, value: 80)
      create(:measurement, goal: goal, date: Date.today, value: 70)

      stats = decorate(goal.user)
      expect(stats.current).to eq(70)
    end

    it 'handles missing goal' do
      stats = decorate(build(:user))
      expect(stats.current).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(build(:user, :with_goal))
      expect(stats.current).to eq('?')
    end
  end

  context '#to_go' do
    it 'returns latest measurement minus goal' do
      goal = create(:goal, :with_measurements)
      stats = decorate(goal.user)
      expect(stats.to_go).to eq(goal.user.latest_measurement.value - goal.user.goal.value)
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.to_go).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.to_go).to eq('?')
    end
  end

  context '#projected_value' do
    it 'predicts value at goal end date' do
      goal = create(:goal, value: 50, date: Date.today)
      create(:measurement, goal: goal, date: 5.days.ago, value: 80)
      create(:measurement, goal: goal, date: 3.days.ago, value: 70)

      stats = decorate(goal.user)
      expect(stats.projected_value).to include('55.0')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.projected_value).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.projected_value).to eq('?')
    end

    it 'handles too few measurements' do
      goal = create(:goal)
      create(:measurement, goal: goal)
      stats = decorate(goal.user)
      expect(stats.projected_value).to eq('?')
    end
  end

  context '#projected_date' do
    it 'predicts date at goal end value' do
      goal = create(:goal, value: 50, date: Date.today)
      create(:measurement, goal: goal, date: 5.days.ago, value: 80)
      create(:measurement, goal: goal, date: 3.days.ago, value: 70)

      stats = decorate(goal.user)
      expect(stats.projected_date).to include(format_date(Date.tomorrow))
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.projected_date).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.projected_date).to eq('?')
    end

    it 'handles too few measurements' do
      goal = create(:goal)
      create(:measurement, goal: goal)
      stats = decorate(goal.user)
      expect(stats.projected_date).to eq('?')
    end
  end

  context '#chart_definition' do
    it 'returns json chart data' do
      goal = create(:goal)
      create(:measurement, goal: goal, date: Date.yesterday, value: 60)
      create(:measurement, goal: goal, date: Date.today, value: 55)

      definition = decorate(goal.user).chart_definition
      expect(definition).to include_json(
        type: 'scatter',
        data: {
          datasets: [
            {
              data:[
                { x: Date.today.strftime('%Y-%m-%d'), y: '55.0' },
                { x: Date.yesterday.strftime('%Y-%m-%d'), y: '60.0' }
              ]
            }
          ]
        }
      )
    end
  end

  def decorate(user)
    stats = UserStatsDecorator.decorate(user)
  end
end