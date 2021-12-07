module Pro
  class Api::V3::BlogSerializer < ApplicationSerializer
    attributes :id, :title, :image_url,
               :summary, :body, :author, :status, :carousel_text
  end
end