# frozen_string_literal: true

class StylistMessage < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_by_stylist_message, against: [:name, :id, :email],
  associated_against: {
    stylist: [:name],
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  has_paper_trail

  after_create :send_email

  belongs_to :stylist
  belongs_to :visit

  def as_json(_options = {})
    super(methods: %i[stylist_name])
  end

  def stylist_name
    stylist ? stylist.name : ''
  end

  def send_email
    if stylist
      email = PublicWebsiteMailer.stylist_message(self)
      email&.deliver
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
