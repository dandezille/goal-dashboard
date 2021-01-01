require 'rails_helper'

RSpec.describe 'Measurements' do
  describe 'POST /measurements' do
    let(:user) { create(:user) }
    let(:goal) { create(:goal, user: user) }
    let(:attributes) { attributes_for(:measurement) }

    before do
      post goal_measurements_path(goal, as: user),
        params: { measurement: attributes }
    end

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:goal) { create(:goal) }
    end

    context 'when user signed in' do
      context 'measurement is created' do
        let(:measurement) { Measurement.first }

        it { is_expected.to redirect_to(goal_path(goal)) }
        it { expect(Measurement.count).to eq(1) }
        it { expect(flash[:notice]).to be_present }

        it 'populates fields' do
          expect(measurement.goal).to eq(user.goals.first)
          expect(measurement.date).to eq(attributes[:date].to_date)
          expect(measurement.value).to eq(attributes[:value])
        end
      end

      context 'with invalid input' do
        let(:attributes) { attributes_for(:measurement, date: '') }

        it { is_expected.to redirect_to(goal_path(goal)) }
        it { expect(Measurement.count).to eq(0) }
        it { expect(flash[:alert]).to be_present }
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }

        it { is_expected.to redirect_to(goals_path) }
        it { expect(Measurement.count).to eq(0) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end

  describe 'DELETE /measurements/:id' do
    let(:user) { create(:user, :with_goal) }
    let(:goal) { create(:goal, user: user) }
    let(:measurement) { create(:measurement, goal: goal) }

    before do
      delete measurement_path(measurement, as: user)
    end

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:measurement) { create(:measurement) }
    end

    context 'when user signed in' do
      context 'measurement is deleted' do
        it { is_expected.to redirect_to(goal_path(goal)) }
        it { expect(Measurement.count).to eq(0) }
        it { expect(flash[:notice]).to be_present }
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }

        it { is_expected.to redirect_to(goals_path) }
        it { expect(Measurement.count).to eq(1) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end
end
