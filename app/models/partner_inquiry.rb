# frozen_string_literal: true

class PartnerInquiry < ActiveRecord::Base
  has_paper_trail

  after_create :send_notification_email
  belongs_to :visit

  private

    def send_notification_email
      email = PublicWebsiteMailer.partner_inquiry(self)
      email&.deliver
    end
end

# == Schema Information
#
# Table name: partner_inquiries
#
#  id           :integer          not null, primary key
#  company_name :string(255)
#  email        :string(255)
#  message      :text
#  name         :string(255)
#  phone        :string(255)
#  request_url  :string(255)
#  subject      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  visit_id     :integer
#
# Indexes
#
#  index_partner_inquiries_on_visit_id  (visit_id)
#
