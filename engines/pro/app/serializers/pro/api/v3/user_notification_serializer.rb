# frozen_string_literal: true

module Pro
  class Api::V3::UserNotificationSerializer < ApplicationSerializer
    attributes :id

    belongs_to :notification
  end
end
