class DashboardController < ApplicationController
  before_action :require_login

  def index
    @dash = UserStatsDecorator.decorate(current_user)
  end
end
