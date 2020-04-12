require 'rails_helper'

RSpec.feature 'User adds a measurement' do
  before { sign_in }

  scenario 'it is created' do
    visit root_path
    fill_form_and_submit(:measurement, attributes_for(:measurement))
    expect(page).to have_css('.flash.notice', text: 'Measurement created')
    expect(Measurement.count).to eq(1)
  end

  def sign_in
    @current_user = create(:user)
    visit root_path(as: @current_user)
  end
end
