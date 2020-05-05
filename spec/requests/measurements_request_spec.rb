require 'rails_helper'

RSpec.describe 'Measurements' do
  describe 'POST /measurements' do
    context 'when user signed in' do
      before { sign_in_as create(:user, :with_goal) }

      it 'creates a measurement' do
        measurement_attributes = attributes_for(:measurement)

        expect do
          post measurements_path,
               params: { measurement: measurement_attributes }
        end.to change(Measurement, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present

        measurement = Measurement.first
        expect(measurement.goal).to eq(@current_user.goal)
        expect(measurement.date).to eq(measurement_attributes[:date].to_date)
        expect(measurement.value).to eq(measurement_attributes[:value])
      end

      it 'shows errors for invalid input' do
        expect do
          post measurements_path,
               params: { measurement: attributes_for(:measurement, date: '') }
        end.not_to change(Measurement, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    it 'requires a goal' do
      sign_in
      measurement_attributes = attributes_for(:measurement)

      expect do
        post measurements_path, params: { measurement: measurement_attributes }
      end.not_to change(Measurement, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end

    it 'redirects if not signed in' do
      expect do
        post measurements_path,
             params: { measurement: attributes_for(:measurement) }
      end.not_to change(Measurement, :count)

      expect(response).to redirect_to(sign_in_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe 'DELETE /measurements/:id' do
    context 'when user signed in' do
      before { sign_in_as create(:user, :with_goal) }

      it 'deletes the given measurement' do
        measurement = create(:measurement, goal: current_user.goal)

        expect { delete measurement_path(measurement) }.to change(
          Measurement,
          :count
        ).by(-1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end

      it 'fails for other users measurements' do
        measurement = create(:measurement)

        expect { delete measurement_path(measurement) }.not_to change(
          Measurement,
          :count
        )

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    it 'redirects if not signed in' do
      measurement = create(:measurement)

      expect { delete measurement_path(measurement) }.not_to change(
        Measurement,
        :count
      )

      expect(response).to redirect_to(sign_in_path)
      expect(flash[:alert]).to be_present
    end
  end
end
