class ApplicationController < ActionController::Base
  include Clearance::Controller

  def require_goal(id_field = :id)
    @goal = Goal.find_by(id: params[id_field])
    if @goal.nil? || @goal.user != current_user
      flash[:alert] = 'Invalid goal'
      redirect_to goals_path
    end
  end

  def require_measurement(id_field = :id)
    @measurement = Measurement.find_by(id: params[id_field])
    if @measurement.nil? || @measurement.goal.user != current_user
      flash[:alert] = 'Invalid measurement'
      redirect_to goals_path
    end
  end
end
