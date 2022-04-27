# frozen_string_literal: true

class EmailEvent < ActiveRecord::Base
end

# == Schema Information
#
# Table name: email_events
#
#  id            :integer          not null, primary key
#  attempt       :text
#  category      :text
#  email         :text
#  event         :text
#  ip            :text
#  reason        :text
#  response      :text
#  status        :text
#  timestamp     :text
#  tls           :text
#  url           :text
#  useragent     :text
#  created_at    :datetime
#  updated_at    :datetime
#  sg_event_id   :text
#  sg_message_id :text
#  smtp_id       :text
#
