class ProBeautyIndustryCategory < ActiveRecord::Base
  has_many :pro_beauty_industries

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 30 }
end

# == Schema Information
#
# Table name: pro_beauty_industry_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#