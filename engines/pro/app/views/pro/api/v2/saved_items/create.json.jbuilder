json.action @saved_item.persisted? ? 'saved' : 'removed'
json.saved_item do
  json.partial! 'saved_item', saved_item: @saved_item
end