class GoalsController < ApplicationController
  before_action :require_login
  before_action :find_goal, only: %i[show edit update destroy]

  def index
    if current_user.goals.any?
      @goals = current_user.goals
      render :index
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

  def destroy
    @goal.destroy!
    redirect_to goals_path
  end

  private
  
  def find_goal
    @goal = Goal.find_by(id: params[:id])
    if @goal.nil? || @goal.user != current_user
      flash[:alert] = 'Invalid goal'
      redirect_to goals_path
    end
  end

  def create_goal
    @goal = current_user.goals.create(goal_params)
  end

  def goal_params
    params.require(:goal).permit(:title, :units, :date, :target)
  end
end
