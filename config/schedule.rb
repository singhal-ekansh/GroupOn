# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, "development"

every :day, at: '12:00am' do
  runner "ProcessDealOrdersJob.perform_later"
end
