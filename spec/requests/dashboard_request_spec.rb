require 'rails_helper'

RSpec.describe 'Dashboards' do

  describe 'GET /index' do
    it 'is successful' do
      get root_path
      expect(response).to be_successful
    end

    it 'redirects if not signed in' do
      get root_path
      expect(response).to redirect_to(sign_in_path)
    end
  end

end
