require 'rails_helper'

RSpec.describe Measurement do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe '.all' do
    it 'returns the most recent measurement first' do
      yesterday = create(:measurement, date: Date.yesterday)
      today = create(:measurement, date: Date.today)
      all = Measurement.all
      expect(all).to eq([today, yesterday])
    end
  end
end
