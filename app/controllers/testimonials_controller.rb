class TestimonialsController < PublicWebsiteController
  def index
  	if I18n.locale.to_s == 'en-CA' 
  		render 'index_ca'
  	end
    #@category = BlogCategory.find_by(:url_name => 'stylist_profiles')
    #@related_blogs = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ?', @category.id).order(:created_at => :desc).uniq if @category
  end
end
