require 'rails_helper'

RSpec.describe 'Measurements' do

  describe 'POST /measurements' do
    it 'creates a measurement' do
      measurement_attributes = attributes_for(:measurement)
      post measurements_path, params: { measurement: measurement_attributes }

      expect(response).to redirect_to(root_path)
      expect(Measurement.count).to eq(1)

      measurement = Measurement.first
      expect(measurement.date).to eq(measurement_attributes[:date].to_date)
      expect(measurement.value).to eq(measurement_attributes[:value])
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
