class ToolCategoryTool < ActiveRecord::Base
  belongs_to :tool
  belongs_to :tool_category

  validates :tool, uniqueness: { scope: :tool_category }
end

# == Schema Information
#
# Table name: tool_category_tools
#
#  id               :integer          not null, primary key
#  tool_id          :integer
#  tool_category_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_tool_category_tools_on_tool_category_id  (tool_category_id)
#  index_tool_category_tools_on_tool_id           (tool_id)
#
