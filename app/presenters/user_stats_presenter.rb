class UserStatsPresenter < BasePresenter
  def current
    measurements.order(:date).first&.value || '?'
  end
end