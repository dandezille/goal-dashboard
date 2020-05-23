require 'rails_helper'

RSpec.describe 'Measurements' do
  describe 'POST /measurements' do
    let(:user) { create(:user, :with_goal) }

    it_behaves_like 'requires sign in' do
      before do
        post goal_measurements_path(user.goals.first),
             params: { measurement: attributes_for(:measurement) }
      end
    end

    context 'when user signed in' do
      before { sign_in_as user }

      it 'creates a measurement' do
        measurement_attributes = attributes_for(:measurement)

        expect do
          post goal_measurements_path(user.goals.first),
               params: { measurement: measurement_attributes }
        end.to change(Measurement, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present

        measurement = Measurement.first
        expect(measurement.goal).to eq(user.goals.first)
        expect(measurement.date).to eq(measurement_attributes[:date].to_date)
        expect(measurement.value).to eq(measurement_attributes[:value])
      end

      it 'shows errors for invalid input' do
        expect do
          post goal_measurements_path(user.goals.first),
               params: { measurement: attributes_for(:measurement, date: '') }
        end.not_to change(Measurement, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end

      it 'requires the user to own the goal' do
        goal = create(:goal)
        measurement_attributes = attributes_for(:measurement)

        expect do
          post goal_measurements_path(goal),
               params: { measurement: measurement_attributes }
        end.not_to change(Measurement, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE /measurements/:id' do
    it_behaves_like 'requires sign in' do
      before do
        measurement = create(:measurement)
        delete goal_measurement_path(measurement.goal, measurement)
      end
    end

    context 'when user signed in' do
      before { sign_in_as create(:user, :with_goal) }

      it 'deletes the given measurement' do
        measurement = create(:measurement, goal: current_user.goals.first)

        expect {
          delete goal_measurement_path(measurement.goal, measurement)
        }.to change(Measurement, :count).by(-1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end

      it 'fails for other users measurements' do
        measurement = create(:measurement)

        expect {
          delete goal_measurement_path(measurement.goal, measurement)
        }.not_to change(Measurement, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
