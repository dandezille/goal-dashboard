class DashboardController < ApplicationController
  before_action :require_login

  def index
    @stats = UserStatsDecorator.decorate(current_user)
  end
end
