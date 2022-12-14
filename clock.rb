# frozen_string_literal: true

require File.expand_path('config/boot', __dir__)
require File.expand_path('config/environment', __dir__)
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

  every(1.day, 'sitemap.refresh', at: '03:50', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake sitemap:refresh`
  end

  every(1.hour, 'blog.publish') do
    `rake blog:publish`
  end

  every(1.day, 'callfire.stylists', at: '09:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    Callfire::StylistsJob.perform_async
  end

  every(1.day, 'callfire.franchises', at: '08:30', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    Callfire::FranchisesJob.perform_async
  end

  every(1.day, 'mailchimp.franchises', at: '11:30', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    Mailchimp::FranchisesJob.perform_async
  end

  every(1.day, 'umsw.auto_approves', at: '06:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake umsw:auto_approves`
  end

  every(1.day, 'umsw.one_week_before_reminder', at: '06:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake umsw:one_week_before_reminder`
  end

  every(1.day, 'umsw.two_days_before_reminder', at: '07:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake umsw:two_days_before_reminder`
  end

  every(10.minutes, 'stylist.turn_off_walkins') do
    `rake stylist:turn_off_walkins`
  end

  every(1.day, 'stylist.sync_with_hubspot', at: '08:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    Hubspot::StylistsAllJob.perform_async
  end

  every(1.day, 'reports.monthly', at: '09:00', if: ->(t) { t.mday == 1 && ENV['ALLOW_CLOCKWORK'].present? }) do
    Reports::MonthlyJob.perform_async
  end

  # every(1.day, 'reports.monthly', at: '03:00', if: lambda { |t| t.mday == 1 && ENV['ALLOW_CLOCKWORK'].present? }) do
  #   RentManager::SyncJob.perform_async
  # end

  # jobs for Pro::Engine

  every(1.day, 'engines.pro.view_update', at: '08:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake view:update`
  end

  every(1.day, 'engines.pro.pg_search.multisearch.rebuild.category', at: '08:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake pg_search:multisearch:rebuild[Category]`
  end

  every(1.day, 'engines.pro.pg_search.multisearch.rebuild.tool', at: '09:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake pg_search:multisearch:rebuild[Tool]`
  end

  every(1.day, 'engines.pro.pg_search.multisearch.rebuild.video', at: '09:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake pg_search:multisearch:rebuild[Video]`
  end

  every(1.day, 'engines.pro.pg_search.multisearch.rebuild.brand', at: '08:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake pg_search:multisearch:rebuild[Brand]`
  end

  every(1.day, 'engines.pro.pg_search.multisearch.rebuild.sola_class', at: '08:00', if: ->(_t) { ENV['ALLOW_CLOCKWORK'].present? }) do
    `rake pg_search:multisearch:rebuild[SolaClass]`
  end
end
