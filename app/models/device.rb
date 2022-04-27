# frozen_string_literal: true

class Device < ActiveRecord::Base
  belongs_to :userable, polymorphic: true
  validates :uuid, :token, :platform, presence: true
  validates :userable_id, :userable_type, presence: true
end

# == Schema Information
#
# Table name: devices
#
#  id                              :integer          not null, primary key
#  app_version                     :string
#  internal_feedback               :text
#  internal_rating_popup_showed_at :datetime
#  name                            :string(255)
#  native_rating_popup_showed_at   :datetime
#  platform                        :string(255)      not null
#  token                           :string(255)      not null
#  userable_type                   :string(255)      not null
#  uuid                            :string(255)      not null
#  created_at                      :datetime
#  updated_at                      :datetime
#  userable_id                     :integer          not null
#
# Indexes
#
#  index_devices_on_token                                   (token) UNIQUE
#  index_devices_on_userable_id                             (userable_id)
#  index_devices_on_userable_type                           (userable_type)
#  index_devices_on_uuid                                    (uuid)
#  index_devices_on_uuid_and_userable_type_and_userable_id  (uuid,userable_type,userable_id) UNIQUE
#
