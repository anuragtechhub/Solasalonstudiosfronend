module Pro
  class Api::V3::UserNotificationSerializer < ApplicationSerializer
    attributes :id

    belongs_to :notification
  end
end