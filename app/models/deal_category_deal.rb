# frozen_string_literal: true

class DealCategoryDeal < ActiveRecord::Base
  belongs_to :deal
  belongs_to :deal_category

  validates :deal, uniqueness: { scope: :deal_category }
end

# == Schema Information
#
# Table name: deal_category_deals
#
#  id               :integer          not null, primary key
#  deal_id          :integer
#  deal_category_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_deal_category_deals_on_deal_category_id  (deal_category_id)
#  index_deal_category_deals_on_deal_id           (deal_id)
#
