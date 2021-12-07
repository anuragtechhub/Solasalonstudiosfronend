json.id saved_item.id
json.item_id saved_item.item_id
json.item_type saved_item.item_type
json.item do
  json.title saved_item.item.title
  json.brand_name saved_item.item.brand_name
  json.description saved_item.item.description
  json.image_url saved_item.item.image_url
  unless saved_item.item_type == 'Video'
    json.file_type saved_item.item.file_content_type
  end
  if saved_item.item_type == 'SolaClass'
    json.video saved_item.item.video
  end
end if saved_item.item.present?