json.array! @brands do |brand|
  json.id brand.id
  json.name brand.name
  json.image_url brand.image_url
  json.introduction_video_heading_title brand.introduction_video_heading_title
  json.events_and_classes_heading_title brand.events_and_classes_heading_title
  json.classes brand.upcoming_classes_by_country(@country) do |klass|
    json.id klass.id
    json.title klass.title
    json.description klass.description
    json.cost klass.cost
    json.image_url klass.image_url
    json.link_url klass.link_url
    json.file_url klass.file_url
    json.rsvp_email_address klass.rsvp_email_address
    json.rsvp_phone_number klass.rsvp_phone_number
    json.location klass.location
    json.address klass.address
    json.city klass.city
    json.state klass.state
    json.start_time klass.start_time
    json.end_time klass.end_time
    json.start_date klass.start_date
    json.end_date klass.end_date
    json.region klass.region
  end
  json.deals brand.deals_by_country(@country) do |deal|
    json.id deal.id
    json.title deal.title
    json.description deal.description
    json.image_url deal.image_url
    json.file_url deal.file_url
    json.more_info_url deal.more_info_url
  end
  json.introduction_video brand.introduction_video_by_country(@country)
  json.links brand.brand_links do |link|
    json.id link.id
    json.link_text link.link_text
    json.link_url link.link_url
  end
  json.product_informations brand.product_informations do |product_information|
    json.id product_information.id
    json.title product_information.title
    json.description product_information.description
    json.image_url product_information.image_url
    json.file_url product_information.file_url
    json.link_url product_information.link_url
  end
  json.tools brand.tools_by_country(@country) do |tool|
    json.id tool.id
    json.title tool.title
    json.description tool.description
    json.image_url tool.image_url
    json.file_url tool.file_url
    json.link_url tool.link_url
    json.youtube_url tool.youtube_url
    json.videos tool.videos
  end
  json.videos brand.brand_videos_by_country(@country) do |video|
    json.id video.id
    json.title video.title
    json.description video.description
    json.duration video.duration
    json.youtube_url video.youtube_url
    json.image_url video.image_url
    json.youtube_video_id video.youtube_video_id
    json.tool_file_url video.tool_file_url
    json.tool_title video.tool_title
  end
  json.past_webinar_videos brand.past_webinar_videos_by_country(@country) do |video|
    json.id video.id
    json.title video.title
    json.description video.description
    json.duration video.duration
    json.youtube_url video.youtube_url
    json.image_url video.image_url
    json.youtube_video_id video.youtube_video_id
    json.tool_file_url video.tool_file_url
    json.tool_title video.tool_title
  end  
end