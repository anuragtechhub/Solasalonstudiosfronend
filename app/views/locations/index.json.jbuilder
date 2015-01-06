json.array!(@locations) do |location|
  json.extract! location, :id, :name, :url_name, :address_1, :address_2, :city, :state, :postal_code, :email_address_for_inquiries, :phone_number, :general_contact_name, :description, :facebook_url, :twitter_url, :latitude, :longitude, :chat_code
  json.url location_url(location, format: :json)
end
