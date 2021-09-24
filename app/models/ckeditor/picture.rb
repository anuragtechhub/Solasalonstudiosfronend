class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => "/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :styles => { :content => '800>', :thumb => '118x100#' }

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_content_type :data, :content_type => /\Aimage/

  def url_content
    url(:content)
  end
end

# == Schema Information
#
# Table name: ckeditor_assets
#
#  id                :integer          not null, primary key
#  assetable_type    :string(30)
#  data_content_type :string(255)
#  data_file_name    :string(255)      not null
#  data_file_size    :integer
#  height            :integer
#  type              :string(30)
#  width             :integer
#  created_at        :datetime
#  updated_at        :datetime
#  assetable_id      :integer
#
# Indexes
#
#  idx_ckeditor_assetable       (assetable_type,assetable_id)
#  idx_ckeditor_assetable_type  (assetable_type,type,assetable_id)
#
