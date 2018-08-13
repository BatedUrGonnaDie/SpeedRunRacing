Delayed::Worker.sleep_delay = 1

if ActiveRecord::Base.connection.table_exists?('delayed_jobs')
  if Delayed::Job.where(queue: 'recurring_cleanup').count.zero?
    RecurringCleanupJob.perform_later
  end
end
