# frozen_string_literal: true

class ShortLink < ActiveRecord::Base
  validates :url, uniqueness: { case_sensitive: false }
  validates :public_id, uniqueness: true

  before_create :generate_public_id

  def short_url
    "https://www.solapro.co/r/#{public_id}"
  end

  private

    def generate_pid
      [*('a'..'z'), *('A'..'Z'), *('0'..'9'), *('0'..'9')].sample(7).join
    end

    def generate_public_id
      pid = generate_pid

      pid = generate_pid while ShortLink.where(public_id: pid).size.positive?

      self.public_id = pid
    end
end

# == Schema Information
#
# Table name: short_links
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  url        :string(255)
#  view_count :bigint           default(0)
#  created_at :datetime
#  updated_at :datetime
#  public_id  :string(255)
#
