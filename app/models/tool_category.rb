# frozen_string_literal: true

class ToolCategory < ActiveRecord::Base
  has_many :tool_category_tools
  has_many :tools, through: :tool_category_tools

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }

  def to_param
    name.gsub(' ', '-')
  end
end

# == Schema Information
#
# Table name: tool_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
