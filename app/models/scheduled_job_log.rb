# frozen_string_literal: true
class ScheduledJobLog < ActiveRecord::Base
  enum status: { 'success' => 0, 'error' => 1 }
end

# == Schema Information
#
# Table name: scheduled_job_logs
#
#  id         :integer          not null, primary key
#  action     :string
#  data       :json
#  fired_at   :datetime
#  kind       :string
#  status     :integer
#  created_at :datetime
#  updated_at :datetime
#
