class SideMenuItem < ActiveRecord::Base

  has_many :side_menu_item_countries, :dependent => :destroy
  has_many :countries, -> { uniq }, :through => :side_menu_item_countries

  validates :countries, :name, :position, :action_link, :presence => true

end

# == Schema Information
#
# Table name: side_menu_items
#
#  id          :integer          not null, primary key
#  action_link :string(255)
#  name        :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
