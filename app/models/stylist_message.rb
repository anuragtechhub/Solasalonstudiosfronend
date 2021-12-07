class StylistMessage < ActiveRecord::Base
  has_paper_trail

  after_create :send_email

  belongs_to :stylist
  belongs_to :visit

  def send_email
    if stylist
      email = PublicWebsiteMailer.stylist_message(self)
      email.deliver if email
    end
  end
end

# == Schema Information
#
# Table name: stylist_messages
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  message    :text
#  name       :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  stylist_id :integer
#  visit_id   :integer
#
# Indexes
#
#  index_stylist_messages_on_stylist_id  (stylist_id)
#  index_stylist_messages_on_visit_id    (visit_id)
#
