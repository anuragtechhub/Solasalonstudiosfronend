class SupportCategory < ActiveRecord::Base
  has_many :supports

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 30 }
end

# == Schema Information
#
# Table name: support_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
