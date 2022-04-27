# frozen_string_literal: true

class BrandLink < ActiveRecord::Base
  belongs_to :brand

  def title
    "#{link_text} (#{link_url})"
  end
end

# == Schema Information
#
# Table name: brand_links
#
#  id         :integer          not null, primary key
#  link_text  :string(255)
#  link_url   :string(255)
#  brand_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#
# Indexes
#
#  index_brand_links_on_brand_id  (brand_id)
#
