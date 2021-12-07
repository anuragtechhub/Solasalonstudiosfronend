json.total_pages @total_pages
json.tools @tools
json.brands @brands do |brand|
	json.id brand.id
	json.name brand.name
end
json.categories @categories do |category|
	json.id category.id
	json.name category.name
end 