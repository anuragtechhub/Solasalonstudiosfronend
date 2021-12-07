module Pro
  class Api::V3::DeviceSerializer < ApplicationSerializer
    attributes :id, :name, :uuid, :token, :platform, :app_version,
               :internal_rating_popup_showed_at, :native_rating_popup_showed_at,
               :internal_feedback, :created_at, :updated_at
  end
end