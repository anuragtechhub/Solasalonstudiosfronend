# frozen_string_literal: true

class GetFeatured < ActiveRecord::Base
  validates :name, :email, :phone_number, presence: true
end

# == Schema Information
#
# Table name: get_featureds
#
#  id             :integer          not null, primary key
#  email          :string(255)
#  name           :string(255)
#  phone_number   :string(255)
#  salon_location :string(255)
#  salon_name     :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#
