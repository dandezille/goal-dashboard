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
    it 'returns expected weight given linear progress between goal points' do
      user = create(:user)
      create(:measurement, user: user, date: 2.days.ago, value: 70)
      create(:goal, user: user, date: Date.tomorrow, value: 60)

      stats = decorate(user)
      expect(stats.target).to eq('63.3')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
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
        @user = create(:user)
        create(:measurement, user: @user, date: 2.days.ago, value: 70)
        create(:goal, user: @user, date: Date.tomorrow, value: 60)
      end

      it 'returns delta when on target' do
        create(:measurement, user: @user, date: Date.today, value: 63.3)
        stats = decorate(@user)
        expect(stats.target_delta).to eq('on target')
      end

      it 'returns delta to target when behind' do
        create(:measurement, user: @user, date: Date.today, value: 65)
        stats = decorate(@user)
        expect(stats.target_delta).to eq('1.7 behind')
      end

      it 'returns delta to target when ahead' do
        create(:measurement, user: @user, date: Date.today, value: 62)
        stats = decorate(@user)
        expect(stats.target_delta).to eq('1.3 ahead')
      end
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
      expect(stats.target_delta).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.target_delta).to eq('?')
    end
  end

  context '#daily_goal' do
    it 'returns weight loss required per day to hit target' do
      user = create(:user)
      create(:measurement, user: user, date: 2.days.ago, value: 80)
      create(:goal, user: user, date: Date.tomorrow, value: 70)

      stats = decorate(user)
      expect(stats.daily_goal).to eq('3.33')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
      expect(stats.daily_goal).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.daily_goal).to eq('?')
    end
  end

  context '#current' do
    it 'returns latest measurement value' do
      user = create(:user)
      create(:measurement, date: Date.yesterday, value: 80, user: user)
      create(:measurement, date: Date.today, value: 70, user: user)

      stats = decorate(user)
      expect(stats.current).to eq(70)
    end

    it 'handles missing measurements' do
      stats = decorate(build(:user))
      expect(stats.current).to eq('?')
    end
  end

  context '#to_go' do
    it 'returns latest measurement minus goal' do
      user = create(:user, :with_goal, :with_measurements)
      stats = decorate(user)
      expect(stats.to_go).to eq(user.latest_measurement.value - user.goal.value)
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
      expect(stats.to_go).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.to_go).to eq('?')
    end
  end

  context '#projected_value' do
    it 'predicts value at goal end date' do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, value: 50, date: Date.today)

      stats = decorate(user)
      expect(stats.projected_value).to include('55.0')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
      expect(stats.projected_value).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.projected_value).to eq('?')
    end

    it 'handles too few measurements' do
      user = create(:user, :with_goal)
      create(:measurement, user: user)
      stats = decorate(user)
      expect(stats.projected_value).to eq('?')
    end
  end

  context '#projected_date' do
    it 'predicts date at goal end value' do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, value: 50, date: Date.today)

      stats = decorate(user)
      expect(stats.projected_date).to include(format_date(Date.tomorrow))
    end

    it 'handles missing goal' do
      stats = decorate(create(:user, :with_measurements))
      expect(stats.projected_date).to eq('?')
    end

    it 'handles missing measurements' do
      stats = decorate(create(:user, :with_goal))
      expect(stats.projected_date).to eq('?')
    end

    it 'handles too few measurements' do
      user = create(:user, :with_goal)
      create(:measurement, user: user)
      stats = decorate(user)
      expect(stats.projected_date).to eq('?')
    end
  end

  context '#chart_definition' do
    it 'returns json chart data' do
      user = create(:user)
      create(:measurement, user: user, date: Date.yesterday, value: 60)
      create(:measurement, user: user, date: Date.today, value: 55)

      definition = decorate(user).chart_definition
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