# https://thoughtbot.com/blog/data-migrations-in-rails

namespace :measurements do
  desc "Create goals for users who have measurements"
  task move_to_goals: :environment do
    users = User.joins(:measurements).distinct
    puts "Going to update #{users} users"

    ActiveRecord::Base.transaction do
      users.each do |user|
        if not user.goal
          measurement = user.latest_measurement
          user.create_goal!(date: measurement.date, value: measurement.value)
        end

        user.measurements.each do |measurement|
          measurement.goal = user.goal
        end

        print '.'
      end

    end

    puts " All done!"
  end
end