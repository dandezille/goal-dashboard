require 'rails_helper'

RSpec.feature 'User sets goal' do
  before { sign_in }

  scenario 'for the first time' do
    new_goal = fill_goal

    expect(page).to have_flash_notice('Goal set')
    expect(current_user.goal.end_value).to eq(new_goal[:end_value])
    expect(current_user.goal.end_date).to eq(Date.parse(new_goal[:end_date]))
  end

  scenario 'when goal exists' do
    create(:goal, user: current_user)
    new_goal = fill_goal

    expect(page).to have_flash_notice('Goal updated')
    expect(current_user.goal.end_value).to eq(new_goal[:end_value])
    expect(current_user.goal.end_date).to eq(Date.parse(new_goal[:end_date]))
  end

  def fill_goal
    goal_attributes = attributes_for(:goal)
    visit root_path
    within('#goal_form') do
      fill_form_and_submit(:goal, goal_attributes)
    end
    current_user.reload

    goal_attributes
  end

  def have_goal(goal)
    have_css '#goal', text: "#{'%.1f' % goal[:end_value]} by #{goal[:end_date]}"
  end
end
