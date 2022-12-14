# frozen_string_literal: true

module Pro
  class Api::V3::SolaClassSerializer < ApplicationSerializer
    attributes :id, :title, :image_url, :file_url, :description,
               :start_date, :start_time,
               :link_text, :link_url,
               :address, :location, :city, :state, :cost, :views,
               :rsvp_email_address, :rsvp_phone_number

    belongs_to :video
    belongs_to :category
    belongs_to :class_image
    has_many :brands
  end
end
