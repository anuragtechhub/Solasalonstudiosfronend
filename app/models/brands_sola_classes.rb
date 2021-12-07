class BrandsSolaClasses < ActiveRecord::Base
  belongs_to :brand
  belongs_to :sola_class
end

# == Schema Information
#
# Table name: brands_sola_classes
#
#  id            :integer          not null, primary key
#  brand_id      :integer
#  sola_class_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_brands_sola_classes_on_brand_id       (brand_id)
#  index_brands_sola_classes_on_sola_class_id  (sola_class_id)
#
