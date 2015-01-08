json.array!(@stylists) do |stylist|
  json.extract! stylist, :id, :name, :url_name, :biography, :email_address, :phone_number, :studio_number, :work_hours, :website, :business_name, :hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients, :booking_url
  json.url stylist_url(stylist, format: :json)
end
