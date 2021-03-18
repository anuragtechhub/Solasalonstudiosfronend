class Testimonial < ActiveRecord::Base

  has_paper_trail

  def to_html
    html = "<hr>"
    html += "<div><strong>Name</strong>: #{self.name}</div>"
    html += "<div><strong>Text</strong>: #{self.text}</div>"
    html += "<div><strong>Region</strong>: #{self.region}</div>"
    html += "<br>"
    html.html_safe
  end
end

# == Schema Information
#
# Table name: testimonials
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  region     :string(255)
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#
