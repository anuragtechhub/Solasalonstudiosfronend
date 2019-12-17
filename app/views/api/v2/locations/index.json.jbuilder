json.data @locations do |location|
  json.id location.id
  json.name location.name
  #json.description location.description
  json.url location.canonical_url
  json.address_1 location.address_1
  json.address_2 location.address_2
  json.city location.city
  json.state location.state
  json.postal_code location.postal_code
  json.country location.country
  json.phone_number location.phone_number
  json.general_contact_name location.general_contact_name
  json.email_address_for_inquiries location.email_address_for_inquiries
  json.facebook_url location.facebook_url
  json.twitter_url location.twitter_url
  json.pinterest_url location.pinterest_url
  json.instagram_url location.instagram_url
  json.yelp_url location.yelp_url
  json.images location.images
  json.floorplan_image location.floorplan_image_file_name.present? ? location.floorplan_image.url(:original) : nil
  json.created_at location.created_at
  json.updated_at location.updated_at  
end