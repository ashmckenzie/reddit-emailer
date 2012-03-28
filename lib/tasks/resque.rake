# require_relative '../init'

# require 'resque/tasks'
# require 'resque_scheduler/tasks'

# Resque.schedule = YAML.load_file('./config/schedule.yml')

require 'resque/tasks'
require 'resque_scheduler/tasks'    

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'      

    Resque.redis = 'localhost:6379'

    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for 
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    #Resque::Scheduler.dynamic = true

    schedule = YAML.load_file('./config/schedule.yml')
    p schedule
    Resque.schedule = schedule

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, someting like this:
    require_relative '../workers/reddit_emailer_worker'        
  end
end