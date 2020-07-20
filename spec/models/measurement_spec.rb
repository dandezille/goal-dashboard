require 'rails_helper'

RSpec.describe Measurement do
  describe 'associations' do
    it { is_expected.to belong_to(:goal) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:goal_id) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'default scope' do
    let!(:today) { create(:measurement, date: Date.today) }
    let!(:yesterday) { create(:measurement, date: Date.yesterday) }

    it 'orders by ascending date' do
      expect(Measurement.all).to eq [yesterday, today]
    end
  end
end
