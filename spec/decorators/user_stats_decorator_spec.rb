require 'rails_helper'

RSpec.describe UserStatsDecorator do
  context '#goal' do
    it 'returns the user goal' do
      user = build(:user, :with_goal)
      stats = decorate(user)
      expect(stats.goal).to eq("#{user.goal.end_value} by #{user.goal.end_date}")
    end

    it 'handles missing goal' do
      stats = decorate(build(:user))
      expect(stats.goal).to eq('No goal set')
    end
  end

  context '#pace' do
    it 'returns 79.1' do
      user = build(:user)
      stats = decorate(user)
      expect(stats.pace).to eq(79.1)
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
    it 'returns 77.5' do
      user = build(:user)
      stats = decorate(user)
      expect(stats.projected_value).to eq(77.5)
    end
  end

  context '#projected_date' do
    it 'returns 30/04/20' do
      user = build(:user)
      stats = decorate(user)
      expect(stats.projected_date).to eq('30/04/20')
    end
  end

  def decorate(user)
    stats = UserStatsDecorator.decorate(user)
  end
end