class GoalsController < ApplicationController
  before_action :require_login

  def create
    if create_goal
      flash[:notice] = 'Goal set'
    else
      flash[:alert] = @goal.errors.messages
    end

    redirect_to root_path
  end

  private

  def create_goal
    @goal = current_user.create_goal(goal_params)
  end

  def goal_params
    params.require(:goal).permit(:date, :value)
  end
end
