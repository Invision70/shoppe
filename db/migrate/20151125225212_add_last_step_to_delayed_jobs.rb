class AddLastStepToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :last_step, :integer
  end
end
