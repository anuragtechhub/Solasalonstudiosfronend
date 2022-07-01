# frozen_string_literal: true

class SideMenuItem < ActiveRecord::Base
    include PgSearch::Model
  pg_search_scope :search_by_side_menu_items, against: [:name],
  associated_against: {
    countries: [:name],
  },
  using: {
    tsearch: {
      prefix: true,
      any_word: true
    }
  }

  has_many :side_menu_item_countries, dependent: :destroy
  has_many :countries, -> { uniq }, through: :side_menu_item_countries

  validates :countries, :name, :position, :action_link, presence: true


  def as_json(_options = {})
      super(include: %i[ countries])
  end

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
