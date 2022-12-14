# frozen_string_literal: true

json.page @page
json.total_count @total_count
json.items @locations.each do |location|
  json.id location.id
  json.name location.name
  json.city location.city
  json.state location.state
end
