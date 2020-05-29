class ApplicationController < ActionController::Base
  include Clearance::Controller

  def require_goal
    @goal = Goal.find_by(id: params[:id])
    if @goal.nil? || @goal.user != current_user
      flash[:alert] = 'Invalid goal'
      redirect_to goals_path
    end
  end
end
