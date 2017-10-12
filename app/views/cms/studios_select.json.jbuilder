json.page @page
json.total_count @total_count
json.items @studios.each do |studio|
  json.id studio.id
  json.name studio.name
end