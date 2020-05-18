require 'rails_helper'

RSpec.describe 'Goals' do
  describe 'GET /goals' do
    context 'when signed out' do
      it 'redirects to sign in' do
        get goals_path
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'when signed in' do
      context 'without goal' do
        before { sign_in }

        it 'redirects to new goal page' do
          get goals_path
          expect(response).to redirect_to(new_goal_path)
        end
      end

      context 'with goal' do
        before { sign_in_as create(:user, :with_goal) }

        it 'redirects to goal page' do
          get goals_path
          expect(response).to redirect_to(goal_path(current_user.goals.first))
        end
      end
    end
  end

  describe 'GET /goal/:id' do
    context 'when signed out' do
      it 'redirects to sign in' do
        goal = create(:goal)
        get goal_path(goal)
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'when signed in' do
      before { sign_in }

      it 'is successful' do
        goal = create(:goal, user: current_user)
        get goal_path(goal)
        expect(response).to be_successful
      end

      it 'shows measurements' do
        goal = create(:goal, :with_measurements, user: current_user)

        get goal_path(goal)
        expect(response).to be_successful

        goal.measurements.each do |measurement|
          expect(response.body).to include(measurement.value.to_s)
        end
      end

      it 'only shows the users goals' do
        goal = create(:goal, :with_measurements)

        get goal_path(goal)
        expect(response).to redirect_to(goals_path)
      end
    end
  end

  describe 'POST /goals' do
    context 'when user signed out' do
      it 'it redirects to sign in path' do
        expect {
          post goals_path, params: { goal: attributes_for(:goal) }
        }.not_to change(Goal, :count)

        expect(response).to redirect_to(sign_in_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user signed in' do
      before { sign_in }

      it 'creates a goal' do
        goal_attributes = attributes_for(:goal)

        expect { post goals_path, params: { goal: goal_attributes } }.to change(
          Goal,
          :count
        ).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present

        goal = Goal.first
        expect(goal.user).to eq(@current_user)
        expect(goal.date).to eq(goal_attributes[:date].to_date)
        expect(goal.value).to eq(goal_attributes[:value])
      end
    end
  end

  describe 'PUT /goal/:id' do
    context 'when user signed out' do
      it 'it redirects to sign in path' do
        goal = create(:goal)
        put goal_path(goal), params: { goal: attributes_for(:goal) }
        expect(response).to redirect_to(sign_in_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user signed in' do
      before { sign_in }

      it 'updates the goal' do
        goal = create(:goal, user: current_user, value: 70)

        expect do
          put goal_path(goal), params: { goal: { value: 60 } }
          goal.reload
        end.to change(goal, :value).from(70).to(60)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
