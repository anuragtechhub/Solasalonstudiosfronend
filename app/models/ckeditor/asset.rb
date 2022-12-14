# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  include Ckeditor::Backend::Paperclip
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
