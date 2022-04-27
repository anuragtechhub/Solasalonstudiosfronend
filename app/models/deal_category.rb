# frozen_string_literal: true

class DealCategory < ActiveRecord::Base
  has_many :deal_category_deals
  has_many :deals, through: :deal_category_deals

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }

  def to_param
    name.gsub(' ', '-')
  end
end

# == Schema Information
#
# Table name: deal_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
