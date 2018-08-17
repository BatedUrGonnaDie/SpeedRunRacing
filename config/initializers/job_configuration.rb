Delayed::Worker.sleep_delay = 1

if ActiveRecord::Base.connection.table_exists?('delayed_jobs') && !Rails.const_defined?('Console')
  # If this statement is on the same line as above it will not short circuit for some reason
  # Putting it in its own evaluation creates a hard short circuit
  # These checks are neccessary because the initial rake db:migrate will call this initializer
  if Delayed::Job.where(queue: 'recurring_cleanup').count.zero?
    RecurringCleanupJob.perform_later
  end
end
