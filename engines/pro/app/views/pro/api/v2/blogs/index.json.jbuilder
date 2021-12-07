json.total_pages @total_pages
json.blogs @blogs
json.categories @categories do |category|
	json.id category.id
	json.name category.name
end 