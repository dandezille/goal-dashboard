require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:measurements) }
    it { is_expected.to have_one(:goal) }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '.latest_measurement' do
    it 'returns the latest measurement' do
      user = create(:user)
      create(:measurement, user: user, date: Date.today - 2.days)
      latest = create(:measurement, user: user, date: Date.today)
      create(:measurement, user: user, date: Date.today - 1.day)

      expect(user.latest_measurement).to eq(latest)
    end
  end

  describe '.first_measurement' do
    it 'returns the first measurement' do
      user = create(:user)
      first = create(:measurement, user: user, date: Date.today - 2.days)
      create(:measurement, user: user, date: Date.today)
      create(:measurement, user: user, date: Date.today - 1.day)

      expect(user.first_measurement).to eq(first)
    end
  end
end
