Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_run_time = 7.days
Delayed::Job.class_eval do
  acts_as_paranoid
end
