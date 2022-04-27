# frozen_string_literal: true

json.total_pages @total_pages
json.videos @videos
json.brands @brands do |brand|
  json.id brand.id
  json.name brand.name
end
json.categories @categories do |category|
  json.id category.id
  json.name category.name
end
