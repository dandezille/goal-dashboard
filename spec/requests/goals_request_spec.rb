require 'rails_helper'

RSpec.describe 'Goals' do
  describe 'GET /goals' do
    before { get goals_path(as: user) }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
    end

    context 'when signed in' do
      context 'without goal' do
        let(:user) { create(:user) }
        it { is_expected.to redirect_to new_goal_path }
      end

      context 'with goal' do
        let(:user) { create(:user, :with_goal) }
        it { expect(response).to be_successful }
        it { is_expected.to render_template(:index) }
        it { expect(assigns(:goals)).to eq(user.goals) }
      end
    end
  end

  describe 'GET /goal/:id' do
    let(:user) { create(:user) }
    let(:goal) { create(:goal, :with_measurements, user: user) }

    before { get goal_path(goal, as: user) }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:goal) { create(:goal) }
    end

    context 'when signed in' do
      it { expect(response).to be_successful }

      it 'shows measurements' do
        goal.measurements.each do |measurement|
          expect(response.body).to include(measurement.value.to_s)
        end
      end

      it 'assigns goal' do
        expect(assigns(:goal)).to eq(goal)
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end

      context 'with invalid goal' do
        let(:goal) { create(:goal, user: user).tap { |g| g.delete } }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end

  describe 'GET /goal/:id/measurements/new' do
    let(:user) { create(:user) }
    let(:goal) { create(:goal, :with_measurements, user: user) }

    before { get new_goal_measurement_path(goal, as: user) }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:goal) { create(:goal) }
    end

    context 'when signed in' do
      it { expect(response).to be_successful }

      it 'assigns measurement' do
        expect(assigns(:measurement)).to be_new_record
        expect(assigns(:measurement).date).to eq(Date.today)
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end

      context 'with invalid goal' do
        let(:goal) { create(:goal, user: user).tap { |g| g.delete } }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end

  describe 'GET /goal/:id/summary' do
    let(:user) { create(:user) }
    let(:goal) { create(:goal, :with_measurements, user: user) }

    before { get goal_summary_path(goal, as: user) }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:goal) { create(:goal) }
    end

    context 'when signed in' do
      it { expect(response).to be_successful }

      it 'assigns goal' do
        expect(assigns(:goal)).to eq(goal)
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end

      context 'with invalid goal' do
        let(:goal) { create(:goal, user: user).tap { |g| g.delete } }
        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end

  describe 'POST /goals' do
    let(:user) { create(:user) }
    let(:attributes) { attributes_for(:goal) }

    before { post goals_path(as: user), params: { goal: attributes } }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
    end

    context 'when user signed in' do
      context 'with valid attributes' do
        let(:goal) { Goal.first }

        it { is_expected.to redirect_to(goal) }
        it { expect(flash[:notice]).to be_present }
        it { expect(Goal.count).to eq(1) }

        it 'populates fields' do
          expect(goal.user).to eq(user)
          expect(goal.title).to eq(attributes[:title])
          expect(goal.date).to eq(attributes[:date].to_date)
          expect(goal.target).to eq(attributes[:target])
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { attributes_for(:goal, title: '') }

        it { is_expected.to render_template(:new) }
        it { expect(flash[:alert]).to be_present }
        it { expect(Goal.count).to eq(0) }
      end
    end
  end

  describe 'PUT /goal/:id' do
    let(:user) { create(:user) }
    let(:goal) { create(:goal, user: user) }
    let(:updated) { Goal.find(goal.id) }
    let(:attributes) { attributes_for(:goal) }

    before { put goal_path(goal, as: user), params: { goal: attributes } }

    it_behaves_like 'requires sign in' do
      let(:user) { nil }
      let(:goal) { create(:goal) }
    end

    context 'when user signed in' do
      context 'goal is updated' do
        it { is_expected.to redirect_to(goal_path(goal)) }
        it { expect(flash[:notice]).to be_present }

        it 'populates fields' do
          expect(updated.title).to eq(attributes[:title])
          expect(updated.date).to eq(attributes[:date].to_date)
          expect(updated.target).to eq(attributes[:target])
        end
      end

      context 'when user doesn\'t own the goal' do
        let(:goal) { create(:goal) }

        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }

        it 'does not change fields' do
          expect(updated.title).to eq(goal.title)
          expect(updated.date).to eq(goal.date)
          expect(updated.target).to eq(goal.target)
        end
      end

      context 'when goal doesn\'t exist ' do
        let(:goal) { create(:goal, user: user).tap { |g| g.delete } }

        it { is_expected.to redirect_to(goals_path) }
        it { expect(flash[:alert]).to be_present }
      end
    end
  end
end
