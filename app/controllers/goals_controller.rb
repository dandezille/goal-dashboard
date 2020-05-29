class GoalsController < ApplicationController
  before_action :require_login
  before_action :require_goal, only: %i[show edit update]

  def index
    redirect_to new_goal_path unless current_user.goals.any?
    @goals = current_user.goals
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
      redirect_to @goal
    else
      flash.now[:alert] = 'Failed to create goal'
      render :new
    end
  end

  def edit; end

  def update
    @goal.update!(goal_params)
    flash[:notice] = 'Goal updated'
    redirect_to goal_path(@goal)
  end

  private
  
  def create_goal
    @goal = current_user.goals.new(goal_params)
    @goal.save
  end

  def goal_params
    params.require(:goal).permit(:title, :units, :date, :target)
  end
end
