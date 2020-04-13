class DashboardController < ApplicationController
  before_action :require_login

  def index
    @measurement = Measurement.new
    @measurements = current_user.measurements
    @stats = UserStatsPresenter.new(current_user, view_context)
  end
end
