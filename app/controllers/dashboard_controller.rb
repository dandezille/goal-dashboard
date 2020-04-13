class DashboardController < ApplicationController
  before_action :require_login

  def index
    @measurement = Measurement.new(date: Date.today)
    @goal = Goal.new
    @measurements = current_user.measurements
    @stats = UserStatsDecorator.decorate(current_user)
  end
end
