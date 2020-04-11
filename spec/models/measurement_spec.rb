require 'rails_helper'

RSpec.describe Measurement do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:value) }
  end
end
