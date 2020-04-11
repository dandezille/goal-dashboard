require 'rails_helper'

RSpec.describe 'Measurements' do

  describe 'POST /measurements' do
    it 'returns http success' do
      post '/measurements'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /measurements/:id' do
    it 'returns http success' do
      measurement = create(:measurement);
      delete "/measurements/#{measurement.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
