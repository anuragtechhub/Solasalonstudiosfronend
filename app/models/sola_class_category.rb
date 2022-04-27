# frozen_string_literal: true

class SolaClassCategory < ActiveRecord::Base
  has_many :sola_classes

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }

  def to_param
    name.gsub(' ', '-')
  end
end

# == Schema Information
#
# Table name: sola_class_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
