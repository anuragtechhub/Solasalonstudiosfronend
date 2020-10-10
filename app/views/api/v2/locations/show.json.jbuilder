json.data @stylists do |stylist|
  json.id stylist.id
  json.name stylist.name
  json.email_address stylist.email_address
  json.phone_number stylist.phone_number
  json.biography stylist.biography
  json.studio_number stylist.studio_number
  json.business_name stylist.business_name
  json.work_hours stylist.work_hours
  json.accepting_new_clients stylist.accepting_new_clients
  json.walkins stylist.walkins
  json.website_url stylist.website_url
  json.booking_url stylist.booking_url
  json.facebook_url stylist.facebook_url
  json.twitter_url stylist.twitter_url
  json.pinterest_url stylist.pinterest_url
  json.instagram_url stylist.instagram_url
  json.yelp_url stylist.yelp_url
  json.services stylist.services
  json.images stylist.images
  json.testimonials stylist.testimonials
  json.created_at stylist.created_at
  json.updated_at stylist.updated_at
end
