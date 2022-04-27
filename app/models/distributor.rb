# frozen_string_literal: true

class Distributor < ActiveRecord::Base
  has_paper_trail

  validates :name, presence: true
  validates :url, url: true, presence: true
end

# == Schema Information
#
# Table name: distributors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
