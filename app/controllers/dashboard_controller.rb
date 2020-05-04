class DashboardController < ApplicationController
  before_action :require_login

  def index
    @dash = current_user.decorate
  end
end
