
RSpec.describe 'goals/_description.html.erb' do
  let(:goal) { build(:goal, title: 'Weight', target: 72.32, date: '2020-05-02', units: 'kg', id: 0) }

  it 'shows the target' do
    render 'goals/description', goal: goal 
    expect(rendered).to match /72.3kg/
  end

  it 'shows the date' do
    render 'goals/description', goal: goal 
    expect(rendered).to match /2nd May/
  end

  it 'shows the title' do
    render 'goals/description', goal: goal 
    expect(rendered).to match /Weight/
  end

  it 'shows link to edit goal' do
    render 'goals/description', goal: goal
    expect(rendered).to have_css "a[href=\"#{edit_goal_path(goal)}\"]"
  end
end
