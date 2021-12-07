json.saved_items @saved_items do |saved_item|
  json.partial! 'saved_item', saved_item: saved_item
end
