require 'rails_helper'

RSpec.describe UserStatsDecorator do
  before { @user = build(:user) }

  context '#pace' do
    it 'returns 79.1' do
      stats = decorate(@user)
      expect(stats.pace).to eq(79.1)
    end
  end

  context '#daily_goal' do
    it 'returns 0.17' do
      stats = decorate(@user)
      expect(stats.daily_goal).to eq(0.17)
    end
  end

  context '#current' do
    it 'returns 79.8' do
      stats = decorate(@user)
      expect(stats.current).to eq(79.8)
    end
  end

  context '#to_go' do
    it 'returns 3.8' do
      stats = decorate(@user)
      expect(stats.to_go).to eq(3.8)
    end
  end

  context '#projected_value' do
    it 'returns 77.5' do
      stats = decorate(@user)
      expect(stats.projected_value).to eq(77.5)
    end
  end

  context '#projected_date' do
    it 'returns 30/04/20' do
      stats = decorate(@user)
      expect(stats.projected_date).to eq('30/04/20')
    end
  end

  def decorate(user)
    stats = UserStatsDecorator.decorate(user)
  end
end