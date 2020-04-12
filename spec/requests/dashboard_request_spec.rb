require 'rails_helper'

RSpec.describe 'Dashboards' do

  describe 'GET /index' do
    it 'is successful' do
      get root_path
      expect(response).to be_successful
    end
  end

end
