# frozen_string_literal: true

class TerminatedStylist < ActiveRecord::Base
  belongs_to :location
end

# == Schema Information
#
# Table name: terminated_stylists
#
#  id                 :integer          not null, primary key
#  email_address      :string(255)
#  name               :string(255)
#  phone_number       :string(255)
#  studio_number      :string(255)
#  stylist_created_at :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  location_id        :integer
#
# Indexes
#
#  index_terminated_stylists_on_location_id  (location_id)
#
