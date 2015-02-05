class Testimonial < ActiveRecord::Base


  def to_html
    html = "<hr>"
    html += "<div><strong>Name</strong>: #{self.name}</div>"
    html += "<div><strong>Text</strong>: #{self.text}</div>"
    html += "<div><strong>Region</strong>: #{self.region}</div>"
    html += "<br>"
    html.html_safe
  end
end
