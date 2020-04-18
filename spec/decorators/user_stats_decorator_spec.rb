require 'rails_helper'

RSpec.describe UserStatsDecorator do
  context '#goal' do
    it 'returns the user goal' do
      user = build(:user, :with_goal)
      goal = decorate(user).goal
      expect(goal).to include(user.goal.end_value.to_s)
      expect(goal).to include(format_date(user.goal.end_date))
    end

    it 'handles missing goal' do
      stats = decorate(build(:user))
      expect(stats.goal).to eq('No goal set')
    end
  end

  context '#target' do
    it 'returns expected weight given linear progress between goal points' do
      goal = create(:goal, start_date: 2.days.ago, start_value: 70, end_date: Date.tomorrow, end_value: 60)
      stats = decorate(goal.user)
      expect(stats.target).to eq('63.3')
    end

    it 'handles missing goal' do
      stats = decorate(create(:user))
      expect(stats.target).to eq('?')
    end
  end

  context '#target_delta' do
    it 'returns delta when on target' do
      goal = create(:goal, start_date: 2.days.ago, start_value: 70, end_date: Date.tomorrow, end_value: 60)
      create(:measurement, user: goal.user, date: Date.today, value: 63.3)
      stats = decorate(goal.user)
      expect(stats.target_delta).to eq('on target')
    end

    it 'returns delta to target when behind' do
      goal = create(:goal, start_date: 2.days.ago, start_value: 70, end_date: Date.tomorrow, end_value: 60)
      create(:measurement, user: goal.user, date: Date.today, value: 65)
      stats = decorate(goal.user)
      expect(stats.target_delta).to eq('1.7 behind')
    end

    it 'returns delta to target when ahead' do
      goal = create(:goal, start_date: 2.days.ago, start_value: 70, end_date: Date.tomorrow, end_value: 60)
      create(:measurement, user: goal.user, date: Date.today, value: 62)
      stats = decorate(goal.user)
      expect(stats.target_delta).to eq('1.3 ahead')
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
      create(:goal, user: user, end_date: Date.tomorrow, end_value: 70)
      create(:measurement, user: user, date: 2.days.ago, value: 80)
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
      first = create(:measurement, date: Date.yesterday, value: 80, user: user)
      second = create(:measurement, date: Date.today, value: 70, user: user)
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
      expect(stats.to_go).to eq(user.latest_measurement.value - user.goal.end_value)
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
    it 'when target can be achieved it returns goal end value' do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, end_value: 60, end_date: Date.today)
      stats = decorate(user)
      expect(stats.projected_value).to eq('60.0')
    end

    it "when target can't be achieved it returns preducted value at goal end date" do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, end_value: 50, end_date: Date.today)
      stats = decorate(user)
      expect(stats.projected_value).to eq('55.0')
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
    it 'when target can be achieved it returns predicted goal date' do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, end_value: 60, end_date: Date.today)
      stats = decorate(user)
      expect(stats.projected_date).to eq(Date.yesterday)
    end

    it "when target can't be achieved it returns goal end date" do
      user = create(:user)
      create(:measurement, user: user, date: 5.days.ago, value: 80)
      create(:measurement, user: user, date: 3.days.ago, value: 70)
      create(:goal, user: user, end_value: 50, end_date: Date.today)
      stats = decorate(user)
      expect(stats.projected_date).to eq(Date.today)
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
                { x: 0, y: "55.0" },
                { x: -1, y: "60.0" }
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