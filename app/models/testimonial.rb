# frozen_string_literal: true

class Testimonial < ActiveRecord::Base
  include PgSearch
  before_validation :process_name
  validates :text, presence: true

  has_paper_trail

  def to_html
    html = '<hr>'
    html += "<div><strong>Name</strong>: #{name}</div>"
    html += "<div><strong>Text</strong>: #{text}</div>"
    html += "<div><strong>Region</strong>: #{region}</div>"
    html += '<br>'
    html.html_safe
  end

  pg_search_scope :search_testimonial, against: %i[id name text region],
    using: {
      tsearch: {
        prefix: true
      }
    }

  private

    def process_name
      return if name.blank?

      self.name = name.to_s.gsub('undefined', '').strip
    end
end

# == Schema Information
#
# Table name: testimonials
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  region     :string(255)
#  text       :text             not null
#  created_at :datetime
#  updated_at :datetime
#
