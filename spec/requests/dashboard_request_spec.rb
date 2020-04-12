require 'rails_helper'

RSpec.describe 'Dashboards' do

  describe 'GET /index' do
    context 'when user is signed in' do
      before { sign_in }

      it 'is successful' do
        get root_path
        expect(response).to be_successful
      end

      it 'shows users measurements' do
        measurement = create(:measurement, user: current_user)

        get root_path
        expect(response).to be_successful
        expect(response.body).to include(measurement.value.to_s)
      end

      it 'does not show others measurements' do
        measurement = create(:measurement)

        get root_path
        expect(response).to be_successful
        expect(response.body).not_to include(measurement.value.to_s)
      end
    end
    
    it 'redirects if not signed in' do
      get root_path
      expect(response).to redirect_to(sign_in_path)
    end
  end

end
