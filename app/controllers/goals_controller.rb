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
    if current_user.goal
      current_user.goal.destroy
    end

    @goal = current_user.create_goal(goal_params)
  end

  def goal_params
    params.require(:goal).permit(:start_date, :end_date, :start_value, :end_value)
  end
end
