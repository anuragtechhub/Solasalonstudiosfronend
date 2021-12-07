module Pro
  class Api::V3::AdminSerializer < ApplicationSerializer
    attributes :id, :email_address
    attribute(:name) { object.email }
    attribute(:class_name) { object.class.name }
    attribute(:onboarded) { true }
    attribute :video_history_data
    attribute :app_settings

    has_many :brands
    has_many :categories
  end
end