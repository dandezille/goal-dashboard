require 'rails_helper'

RSpec.describe 'Goals' do

  describe 'POST /goals' do
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
        expect(goal.date).to eq(goal_attributes[:date].to_date)
        expect(goal.value).to eq(goal_attributes[:value])
      end

      it 'clears an existing goal' do
        sign_in_as(create(:user, :with_goal))

        goal_attributes = attributes_for(:goal)
        post goals_path, params: { goal: goal_attributes }

        expect(response).to redirect_to(root_path)
        expect(Goal.count).to eq(1)
        expect(flash[:notice]).to be_present

        goal = Goal.first
        expect(goal.user).to eq(@current_user)
        expect(goal.date).to eq(goal_attributes[:date].to_date)
        expect(goal.value).to eq(goal_attributes[:value])
      end
    end
    
    it 'redirects if not signed in' do
      post goals_path, params: { goal: attributes_for(:goal) }
      expect(response).to redirect_to(sign_in_path)
      expect(Goal.count).to eq(0)
      expect(flash[:alert]).to be_present
    end
  end

end
