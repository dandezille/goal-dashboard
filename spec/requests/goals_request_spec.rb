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
        it { is_expected.to redirect_to(goal_path(user.goals.first)) }
      end
    end
  end

  describe 'GET /goal/:id' do
    it_behaves_like 'requires sign in' do
      before { get goal_path(create(:goal)) }
    end

    context 'when signed in' do
      let(:user) { create(:user) }

      it 'is successful' do
        goal = create(:goal, user: user)
        get goal_path(goal, as: user)
        expect(response).to be_successful
      end

      it 'shows measurements' do
        goal = create(:goal, :with_measurements, user: user)

        get goal_path(goal, as: user)
        expect(response).to be_successful

        goal.measurements.each do |measurement|
          expect(response.body).to include(measurement.value.to_s)
        end
      end

      it 'only shows the users goals' do
        goal = create(:goal, :with_measurements)

        get goal_path(goal, as: user)
        expect(response).to redirect_to(goals_path)
      end
      
      it 'must exist' do
        goal = create(:goal)
        goal.delete

        get goal_path(goal, as: user)
        expect(response).to redirect_to(goals_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'POST /goals' do
    it_behaves_like 'requires sign in' do
      before { post goals_path, params: { goal: attributes_for(:goal) } }
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
        expect(goal.title).to eq(goal_attributes[:title])
        expect(goal.date).to eq(goal_attributes[:date].to_date)
        expect(goal.target).to eq(goal_attributes[:target])
      end
    end
  end

  describe 'PUT /goal/:id' do
    it_behaves_like 'requires sign in' do
      before { put goal_path(create(:goal)), params: { goal: attributes_for(:goal) } }
    end

    context 'when user signed in' do
      before { sign_in }

      it 'updates the goal' do
        goal = create(:goal, user: current_user, target: 70)

        expect do
          put goal_path(goal), params: { goal: { target: 60 } }
          goal.reload
        end.to change(goal, :target).from(70).to(60)

        expect(response).to redirect_to(goal_path(goal))
        expect(flash[:notice]).to be_present
      end
       
      it 'must belong to the current user' do
        goal = create(:goal, target: 70)

        expect do
          put goal_path(goal), params: { goal: { target: 60 } }
          goal.reload
        end.not_to change(goal, :target)

        expect(response).to redirect_to(goals_path)
        expect(flash[:alert]).to be_present
      end

      it 'must exist' do
        goal = create(:goal, user: current_user, target: 70)
        goal.delete

        put goal_path(goal), params: { goal: { target: 60 } }
        expect(response).to redirect_to(goals_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
