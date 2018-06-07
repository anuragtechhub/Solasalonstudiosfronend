class Sola10kController < PublicWebsiteController
  
  require 'RMagick'
  #require 'FileUtils'

  skip_before_filter :verify_authenticity_token

  def index
    last_approved_sola10k_image = Sola10kImage.select(:updated_at).order(:updated_at => :desc).first
    cache_key = "/sola10k/approved-images?last_approved_at=#{last_approved_sola10k_image ? last_approved_sola10k_image.updated_at : DateTime.now}"

    @gallery_images = Rails.cache.fetch(cache_key) do   
      Sola10kImage.where(:approved => true).to_a.to_json
    end

    # set MySola blogs
    @category = BlogCategory.find_by(:id => 11)
    @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').uniq.order(:publish_date => :desc)
    @posts = @posts.page(params[:page] || 1)#.per(21)

    render :layout => params[:layout] if params[:layout]
  end

  def show
    @sola10k_image = Sola10kImage.find_by(:public_id => params[:id])
  end

  def image_preview
    # update and save Sola10kImage with statement, variant, etc
    @sola10k_image = Sola10kImage.find_by(:public_id => params[:id]) || Sola10kImage.new
    @sola10k_image.name = params[:name] if params[:name].present?
    @sola10k_image.instagram_handle = params[:instagram_handle] if params[:instagram_handle].present?
    @sola10k_image.statement = params[:statement] if params[:statement].present?
    
    generated_image = generate_image(@sola10k_image.image, @sola10k_image.statement)

    if @sola10k_image.changed?
      #flat_image = Magick::ImageList.new(generated_image).flatten_images
      #p "WE CHANGED!!!"
      # generated_image_file = File.open("mysola#{@sola10k_image.id}.jpg", 'wb') do |file|
      #   file.write generated_image.to_blob
      # end
      generated_image_file = Tempfile.new("sola10k#{@sola10k_image.id}")
      generated_image.write(generated_image_file.path)
      #p "generated_image_file!!!"
      @sola10k_image.generated_image = generated_image_file#File.open("mysola#{@sola10k_image.id}.jpg")
      @sola10k_image.save
      #p "finished saving image to sola10k_image" 
      #FileUtils.rm("mysola#{@sola10k_image.id}.jpg")
      #p "finished removing mysolaimage"
    end
    
    send_data generated_image.to_blob, filename: "sola10k.jpg", type: :jpg
  end

  def image_upload
    @sola10k_image = Sola10kImage.create
    @sola10k_image.image = params[:file]
    @sola10k_image.save

    render :json => @sola10k_image
  end

  private

  def calculate_cursive_pointsize(image, draw, text)
    pointsize = 820
    width = 920
    
    while width >= 920
      pointsize = pointsize - 20
      draw.pointsize = pointsize
      width = draw.get_type_metrics(image, text)[:width]
    end

    pointsize
  end

  def generate_image(image, statement)
    #p "generate image"
    m_image = Magick::Image.read(image.url(:original)).first.resize_to_fill!(1080, 1080)

    # blue overlay
    blue_overlay = Magick::Draw.new
    blue_overlay.fill = 'rgba(73, 156, 211, 0.1)'
    blue_overlay.rectangle(0, 0, 1080, 1080)
    blue_overlay.draw(m_image)

    if statement.present?      
      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/ChaletParisNineteenSixty.ttf"
      cursive_text.gravity = Magick::CenterGravity
      cursive_text.fill = '#ffffff'
      cursive_text_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
      cursive_text.pointsize = cursive_text_pointsize
      m_image.annotate(cursive_text, 1080, 1080, 0, 0, statement) 

      cursive_text_metrics = cursive_text.get_type_metrics(m_image, statement)
      ascent = cursive_text_metrics[:ascent]
      descent = cursive_text_metrics[:descent]
      height = cursive_text_metrics[:height]
      calculated_height = height + descent# + 160
      y_value = -(ascent - (statement =~ /[A-Z]/ ? 50 : 150)) / 2
      #p "height=#{height}, ascent=#{ascent}, descent=#{descent} calculated_height=#{calculated_height}, cursive_text_pointsize=#{cursive_text_pointsize}, #{y_value}"
      # text = Magick::Draw.new
      # m_image.annotate(text, 1080, 1080, 0, y_value, "#MySola is my") do
      #   text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
      #   text.gravity = Magick::CenterGravity
      #   text.pointsize = 70
      #   text.kerning = 2
      #   text.fill = '#ffffff'
      # end      
    end   

    # # I feel [BLANK] in #MySola
    # if statement.present? && statement_variant == 'i_feel'
    #   #p "I feel BlANK"
    #   top_text = Magick::Draw.new
    #   m_image.annotate(top_text, 1080, 1080, 0, 300, "I feel") do
    #     top_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
    #     top_text.gravity = Magick::NorthGravity
    #     top_text.pointsize = 70
    #     top_text.kerning = 2
    #     top_text.fill = '#ffffff'
    #   end

    #   cursive_text = Magick::Draw.new
    #   cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
    #   cursive_text.gravity = Magick::CenterGravity
    #   cursive_text.fill = '#ffffff'
    #   cursive_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
    #   m_image.annotate(cursive_text, 1080, 1080 - 45, 0, 45, statement)
      
    #   bottom_text = Magick::Draw.new
    #   m_image.annotate(bottom_text, 1080, 1080, 0, 760, "in #MySola") do
    #     bottom_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
    #     bottom_text.gravity = Magick::NorthGravity
    #     bottom_text.pointsize = 70
    #     bottom_text.kerning = 2
    #     bottom_text.fill = '#ffffff'
    #   end
    # end  

    
    # my logo
    my_logo = Magick::Image.read(Rails.root.join('app/assets/images/sola10kmy.png')).first
    m_combined = m_image.composite(my_logo, 85, 175, Magick::OverCompositeOp)

    # gradient color overlay
    m_gradient = Magick::Image.read(Rails.root.join('app/assets/images/sola10kgradientblue.png')).first
    m_combined = m_combined.composite(m_gradient, 0, 0, Magick::OverCompositeOp)

    # white stroke
    white_stroke = Magick::Draw.new
    white_stroke.fill_opacity(0)
    white_stroke.stroke('#ffffff')
    white_stroke.stroke_width(4)
    white_stroke.rectangle(40, 40, 1035, 1035)
    white_stroke.draw(m_combined)
    # cursive_text.font = "#{Rails.root}/lib/fonts/ChaletParisNineteenSixty.ttf"
    # cursive_text.gravity = Magick::CenterGravity
    # cursive_text.fill = '#ffffff'
    # cursive_text_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
    # cursive_text.pointsize = cursive_text_pointsize
    #m_combined.annotate(white_stroke, 1080, 1080, 0, 0) 

    # logo (200 x 119)
    # m_logo = Magick::Image.read(Rails.root.join('app/assets/images/sola-logo.png')).first
    # m_combined = m_combined.composite(m_logo, 855, 935, Magick::OverCompositeOp)

    m_combined
  end

end
