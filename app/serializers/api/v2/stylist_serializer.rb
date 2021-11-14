class Api::V2::StylistSerializer < ApplicationSerializer
  attributes :id, :name, :email_address,
             :phone_number, :biography, :studio_number,
             :business_name, :work_hours, :accepting_new_clients,
             :walkins, :website_url, :booking_url, :facebook_url,
             :twitter_url, :pinterest_url, :instagram_url,
             :yelp_url, :tik_tok_url, :services, :images, :testimonials,
             :created_at, :updated_at
end
