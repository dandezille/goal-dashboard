require 'rails_helper'

RSpec.describe 'Goals' do

  describe 'POST /goals' do
    context 'when user signed out' do
      it 'it redirects to sign in path' do
        post goals_path, params: { goal: attributes_for(:goal) }
        expect(response).to redirect_to(sign_in_path)
        expect(Goal.count).to eq(0)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user signed in' do
      before { sign_in }

      it 'creates a goal' do
        goal_attributes = attributes_for(:goal)
        post goals_path, params: { goal: goal_attributes }

        expect(response).to redirect_to(root_path)
        expect(Goal.count).to eq(1)
        expect(flash[:notice]).to be_present

        goal = Goal.first
        expect(goal.user).to eq(@current_user)
        expect(goal.start_date).to eq(goal_attributes[:start_date].to_date)
        expect(goal.end_date).to eq(goal_attributes[:end_date].to_date)
        expect(goal.start_value).to eq(goal_attributes[:start_value])
        expect(goal.end_value).to eq(goal_attributes[:end_value])
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
        goal = create(:goal, user: current_user, end_value: 70)
        put goal_path(goal), params: { goal: { end_value: 60 }}

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present

        goal.reload
        expect(goal.end_value).to eq(60)
      end
    end
  end
end
