RSpec.describe UserStatsPresenter do
  it 'gives current measurement' do
    user = create(:user)
    yesterday = create(:measurement, user: user, date: Date.yesterday)
    today = create(:measurement, user: user, date: Date.today)
    user.reload

    presenter = present(user)
    expect(presenter.current).to eq(today.value)
  end

  def present(user)
    UserStatsPresenter.new(user, view)
  end
end