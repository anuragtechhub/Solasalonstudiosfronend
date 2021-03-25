require File.expand_path('../config/boot', __FILE__)
require File.expand_path('../config/environment', __FILE__)
require 'rubygems'
require 'clockwork'

# All tasks run in PST timezone (UTC-8)
module Clockwork
  configure do |config|
    config[:sleep_timeout] = 5
    config[:logger] = Logger.new(Rails.root.join('log/clockwork.log'))
    config[:tz] = 'America/Los_Angeles'
    config[:max_threads] = 15
    config[:thread] = true
  end

  every(1.day, 'sitemap.refresh', at: '03:50', if: lambda { |t| Rails.env.production? }) do
    `rake sitemap:refresh`
  end

  every(1.hour, 'blog.publish') do
    `rake blog:publish`
  end

  every(1.day, 'callfire.stylists', at: '09:00', if: lambda { |t| Rails.env.production? }) do
    `rake callfire:stylists`
  end

  every(1.day, 'callfire.franchises', at: '08:30', if: lambda { |t| Rails.env.production? }) do
    `rake callfire:franchises`
  end

  every(1.day, 'mailchimp.franchises', at: '11:30', if: lambda { |t| Rails.env.production? }) do
    `rake mailchimp:franchises`
  end

  every(1.day, 'umsw.auto_approves', at: '06:00', if: lambda { |t| Rails.env.production? }) do
    `rake umsw:auto_approves`
  end

  every(1.day, 'umsw.one_week_before_reminder', at: '06:00', if: lambda { |t| Rails.env.production? }) do
    `rake umsw:one_week_before_reminder`
  end

  every(1.day, 'umsw.two_days_before_reminder', at: '07:00', if: lambda { |t| Rails.env.production? }) do
    `rake umsw:two_days_before_reminder`
  end

  every(10.minutes, 'stylist.turn_off_walkins') do
    `rake stylist:turn_off_walkins`
  end

  every(1.day, 'stylist.sync_with_hubspot', at: '08:00', if: lambda { |t| Rails.env.production? }) do
    `rake stylist:sync_with_hubspot`
  end

  every(1.day, 'reports.monthly', at: '09:00', if: lambda { |t| t.mday == 1 && Rails.env.production? }) do
    Reports::MonthlyJob.perform_async
  end

  # every(1.day, 'reports.booknow_biweekly', at: '12:00', if: lambda { |t| t.mday.in?([14, 28]) && Rails.env.production? }) do
  #   Reports::BooknowJob.perform_async(13.days.ago.beginning_of_day, Time.current.end_of_day, 'olivia@solasalonstudios.com')
  # end
end
