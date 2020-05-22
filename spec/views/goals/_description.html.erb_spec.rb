require 'rails_helper'

RSpec.describe 'goals/_description.html.erb' do
  let(:goal) { build(:goal, title: 'Weight', value: 72.32, date: '2020-05-02', units: 'kg', id: 0) }

  it 'displays a summary of the goal' do
    render 'goals/description', goal: goal 
    expect(rendered).to have_content 'Weight 72.3kg by 2nd May', normalize_ws: true
  end

  it 'shows link to edit goal' do
    render 'goals/description', goal: goal
    expect(rendered).to have_css "a[href=\"#{edit_goal_path(goal)}\"]"
  end
end
