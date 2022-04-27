# frozen_string_literal: true

class Api::V2::LocationSerializer < ApplicationSerializer
  attributes :id, :name, :address_1, :address_2, :city, :state,
             :postal_code, :country, :phone_number,
             :general_contact_name, :email_address_for_inquiries,
             :facebook_url, :twitter_url, :pinterest_url,
             :instagram_url, :yelp_url, :images, :created_at, :updated_at
  attribute(:url) { object.canonical_url }
  attribute(:floorplan_image) { object.floorplan_image_file_name.present? ? object.floorplan_image.url(:original) : nil }
end
