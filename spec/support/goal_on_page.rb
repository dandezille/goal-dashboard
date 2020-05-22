class GoalOnPage < Struct.new(:params)
  include Capybara::DSL
  include FormatHelper

  def create
    fill_in 'goal_title', with: params[:title]
    fill_in 'goal_date', with: params[:date]
    fill_in 'goal_value', with: params[:value]
    click_button 'Update goal'
  end

  def edit
    page.find('#goal a').click
    create
  end

  def visible?
    page.has_css? '#goal' do |element|
      element.has_content?(params[:value]) &&
        element.has_content?(format_date(params[:date]))
    end
  end
end
