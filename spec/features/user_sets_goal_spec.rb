require 'rails_helper'

RSpec.feature 'User sets goal' do
  before { sign_in }

  scenario 'it is created' do
    goal_attributes = attributes_for(:goal)
    visit root_path
    within('#new_goal') do
      fill_form_and_submit(:goal, goal_attributes)
    end

    expect(page).to have_flash_notice('Goal set')
    expect(current_user.goal.end_value).to eq(goal_attributes[:end_value])
    expect(current_user.goal.end_date).to eq(Date.parse(goal_attributes[:end_date]))
  end

  def have_goal(goal)
    have_css '#goal', text: "#{'%.1f' % goal[:end_value]} by #{goal[:end_date]}"
  end
end
