# frozen_string_literal: true

json.array! blogs do |blog|
  json.id blog.id
  json.title blog.title
end
