class GoalsController < ApplicationController
  before_action :require_login
  before_action :find_goal, only: [ :show, :update ]

  def index
    if current_user.goal
      redirect_to goal_path(current_user.goal)
    else
      redirect_to new_goal_path 
    end 
  end

  def show
    redirect_to goals_path unless @goal.user == current_user
    @goal = @goal.decorate
    @measurement = Measurement.new
  end

  def new
    @goal = Goal.new
  end

  def create
    if create_goal
      flash[:notice] = 'Goal set'
    else
      flash[:alert] = @goal.errors.messages
    end

    redirect_to root_path
  end

  def update
    @goal.update!(goal_params)
    flash[:notice] = 'Goal updated' 
    redirect_to root_path
  end

  private

  def find_goal
    @goal = Goal.find(params[:id])
  end

  def create_goal
    if current_user.goal
      current_user.goal.destroy
    end

    @goal = current_user.create_goal(goal_params)
  end

  def goal_params
    params.require(:goal).permit(:date, :value)
  end
end
