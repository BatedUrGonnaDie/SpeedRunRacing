Delayed::Worker.sleep_delay = 1
RecurringCleanupJob.perform_later if Delayed::Job.where(queue: 'recurring_cleanup').count.zero?
