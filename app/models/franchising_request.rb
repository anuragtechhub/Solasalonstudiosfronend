class FranchisingRequest < ActiveRecord::Base

  has_paper_trail
  
 	#after_create :send_notification_email
  belongs_to :visit

  # private

  # def send_notification_email
  #   email = PublicWebsiteMailer.franchising_request(self)
  #   email.deliver if email
  # end

end

# == Schema Information
#
# Table name: franchising_requests
#
#  id           :integer          not null, primary key
#  email        :string(255)
#  market       :string(255)
#  message      :text
#  name         :string(255)
#  phone        :string(255)
#  request_type :string(255)
#  request_url  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  visit_id     :integer
#
# Indexes
#
#  index_franchising_requests_on_visit_id  (visit_id)
#
