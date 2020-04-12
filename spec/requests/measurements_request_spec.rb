require 'rails_helper'

RSpec.describe 'Measurements' do

  describe 'POST /measurements' do
    it 'creates a measurement' do
      measurement_attributes = attributes_for(:measurement)
      post measurements_path, params: { measurement: measurement_attributes }

      expect(response).to redirect_to(root_path)
      expect(Measurement.count).to eq(1)
      expect(flash[:notice]).to be_present

      measurement = Measurement.first
      expect(measurement.date).to eq(measurement_attributes[:date].to_date)
      expect(measurement.value).to eq(measurement_attributes[:value])
    end

    it 'shows errors for invalid input' do
      measurement_attributes = attributes_for(:measurement, date: '')
      post measurements_path, params: { measurement: measurement_attributes }

      expect(response).to redirect_to(root_path)
      expect(Measurement.count).to eq(0)
      expect(flash[:alert]).to be_present
    end
  end

  describe 'DELETE /measurements/:id' do
    it 'deletes the given measurement' do
      measurement = create(:measurement);
      delete measurement_path(measurement)

      expect(response).to redirect_to(root_path)
      expect(Measurement.count).to eq(0)
      expect(flash[:notice]).to be_present
    end
  end

end
