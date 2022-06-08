# frozen_string_literal: true

class CallfireLog < ActiveRecord::Base
  self.table_name = :callfire_logs
  enum status: { 'success' => 0, 'error' => 1 }
end

# == Schema Information
#
# Table name: callfire_logs
#
#  id         :integer          not null, primary key
#  action     :string
#  data       :json
#  kind       :string
#  status     :integer
#  created_at :datetime
#  updated_at :datetime
#
