class GoalsController < ApplicationController
  before_action :require_login
  before_action :require_goal, only: %i[show edit update]

  def index
    if current_user.goals.any?
      # TODO show list of goals
      redirect_to goal_path(current_user.goals.first)
    else
      redirect_to new_goal_path
    end
  end

  def show
    @goal = @goal.decorate
    @measurement = Measurement.new(date: Date.today)
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

  def edit; end

  def update
    @goal.update!(goal_params)
    flash[:notice] = 'Goal updated'
    redirect_to goal_path(@goal)
  end

  private
  
  def create_goal
    @goal = current_user.goals.create(goal_params)
  end

  def goal_params
    params.require(:goal).permit(:title, :units, :date, :target)
  end
end
