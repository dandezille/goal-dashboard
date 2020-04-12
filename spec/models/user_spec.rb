require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { should have_many(:measurements) }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end
end
