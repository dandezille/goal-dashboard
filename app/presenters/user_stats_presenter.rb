class UserStatsPresenter < BasePresenter
  def current
    measurements.first&.value || '?'
  end
end