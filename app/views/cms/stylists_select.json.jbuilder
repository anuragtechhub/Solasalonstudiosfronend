# frozen_string_literal: true

json.page @page
json.total_count @total_count
json.items @stylists.each do |stylist|
  json.id stylist.id
  json.name stylist.name
  json.email_address stylist.email_address
  json.website_email_address stylist.website_email_address
end
