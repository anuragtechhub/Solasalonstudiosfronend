class ProBeautyIndustry < ActiveRecord::Base
  belongs_to :brand
  belongs_to :pro_beauty_industry_category
  belongs_to :category

  has_many :taggables, as: :item, dependent: :destroy
  has_many :tags, through: :taggables

  has_paper_trail

  has_attached_file :file, :path => ":class/:attachment/:id_partition/:style/:filename"
  has_attached_file :thumbnail_image, :path => ":class/:attachment/:id_partition/:style/:filename", :styles => { :large => "410x233!", :small => "232x129!" }
  has_attached_file :flyer_image, :path => ":class/:attachment/:id_partition/:style/:filename", :styles => { :large => "976x976!", :small => "488x488!" }

  validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "text/plain", "text/html", "application/msword", "application/vnd.ms-works", "application/rtf", "application/pdf", "application/vnd.ms-powerpoint", "application/x-compress", "application/x-compressed", "application/x-gzip", "application/zip", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "text/csv", "text/tab-separated-values"] }
  validates :title, :length => { :maximum => 35 }, :presence => true
  validates :short_description, :length => { :maximum => 400 }, :presence => true
  validates :long_description, :length => { :maximum => 460 }, :presence => true
  validates :video_url, :url => true
end

# == Schema Information
#
# Table name: pro_beauty_industries
#
#  id                              :integer          not null, primary key
#  title                           :string(255)
#  short_description               :text
#  long_description                :text
#  created_at                      :datetime
#  updated_at                      :datetime
#  file_file_name                  :string(255)
#  file_content_type               :string(255)
#  file_file_size                  :integer
#  file_updated_at                 :datetime
#  video_url                       :string(255)
#  thumbnail_image_file_name       :string(255)
#  thumbnail_image_content_type    :string(255)
#  thumbnail_image_file_size       :integer
#  thumbnail_image_updated_at      :datetime
#  flyer_image_file_name           :string(255)
#  flyer_image_content_type        :string(255)
#  flyer_image_file_size           :integer
#  flyer_image_updated_at          :datetime
#  brand_id                        :integer
#  pro_beauty_industry_category_id :integer
#
# Indexes
#
#  index_pro_beauty_industries_on_brand_id                         (brand_id)
#  index_pro_beauty_industries_on_pro_beauty_industry_category_id  (pro_beauty_industry_category_id)
#
