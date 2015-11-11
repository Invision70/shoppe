Delayed::Worker.destroy_failed_jobs = false
Delayed::Job.class_eval do
  acts_as_paranoid
end