class Testimonial < ActiveRecord::Base

  before_validation :process_name
  validates :text, presence: true

  has_paper_trail

  def to_html
    html = "<hr>"
    html += "<div><strong>Name</strong>: #{self.name}</div>"
    html += "<div><strong>Text</strong>: #{self.text}</div>"
    html += "<div><strong>Region</strong>: #{self.region}</div>"
    html += "<br>"
    html.html_safe
  end

  private

  def process_name
    return if self.name.blank?

    self.name = self.name.to_s.gsub('undefined', '').strip
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
