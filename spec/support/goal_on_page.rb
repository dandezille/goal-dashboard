class GoalOnPage < Struct.new(:params)
  include Capybara::DSL
  include FormatHelper

  def create
    fill_fields
    click_button 'Update goal'
  end

  def edit
    page.find('#goal a').click
    fill_fields
    click_button 'Update goal'
  end

  def visible?
    page.has_css? '#goal' do |element|
      element.has_content?(params[:title]) &&
      element.has_content?(params[:units]) &&
        element.has_content?(params[:target]) &&
        element.has_content?(format_date(params[:date]))
    end
  end

  private

  def fill_fields
    fill_in 'goal_title', with: params[:title]
    fill_in 'goal_units', with: params[:units]
    fill_in 'goal_date', with: params[:date]
    fill_in 'goal_target', with: params[:target]
  end
end
