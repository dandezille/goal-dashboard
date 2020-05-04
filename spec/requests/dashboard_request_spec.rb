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
        goal = create(:goal, :with_measurements, user: current_user)

        get root_path
        expect(response).to be_successful

        goal.measurements.each do |measurement|
          expect(response.body).to include(measurement.value.to_s)
        end
      end

      it 'does not show others measurements' do
        goal = create(:goal, :with_measurements)

        get root_path
        expect(response).to be_successful

        goal.measurements.each do |measurement|
          expect(response.body).not_to include(measurement.value.to_s)
        end
      end
    end
    
    it 'redirects if not signed in' do
      get root_path
      expect(response).to redirect_to(sign_in_path)
    end
  end

end
