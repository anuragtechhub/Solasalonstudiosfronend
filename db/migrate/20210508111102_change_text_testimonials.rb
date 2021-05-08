class ChangeTextTestimonials < ActiveRecord::Migration
  def change
    Testimonial.where(text: nil).delete_all
    Testimonial.where(text: '').delete_all
    change_column :testimonials, :text, :text, null: false
    Testimonial.where('name ilike ?', "%undefined%").find_each do |t|
      t.update_column(:name, t.name.gsub('undefined', '').strip)
    end
  end
end
