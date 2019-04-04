class MySolaController < PublicWebsiteController
  
  require 'RMagick'
  #require 'FileUtils'

  skip_before_filter :verify_authenticity_token

  def index
    last_approved_my_sola_image = MySolaImage.select(:updated_at).order(:updated_at => :desc).first
    cache_key = "/my-sola/approved-images?last_approved_at=#{last_approved_my_sola_image.updated_at}"

    @gallery_images = Rails.cache.fetch(cache_key) do   
      MySolaImage.where(:approved => true).to_a.to_json
    end

    # set MySola blogs
    @category = BlogCategory.find_by(:id => 11)
    @posts = Blog.joins(:blog_categories, :blog_blog_categories).where('blog_blog_categories.blog_category_id = ? AND status = ?', @category.id, 'published').uniq.order(:publish_date => :desc)
    @posts = @posts.page(params[:page] || 1)#.per(21)

    render :layout => params[:layout] if params[:layout]
  end

  def show
    @my_sola_image = MySolaImage.find_by(:public_id => params[:id])
  end

  def image_preview
    # update and save MySolaImage with statement, variant, etc
    @my_sola_image = MySolaImage.find_by(:public_id => params[:id]) || MySolaImage.new
    @my_sola_image.name = params[:name] if params[:name].present?
    @my_sola_image.instagram_handle = params[:instagram_handle] if params[:instagram_handle].present?
    @my_sola_image.statement_variant = params[:statement_variant] if params[:statement_variant].present?
    @my_sola_image.statement = params[:statement] if (params[:statement].present? || @my_sola_image.statement_variant_changed?)
    
    generated_image = generate_image(@my_sola_image.image, @my_sola_image.statement, @my_sola_image.statement_variant)

    if @my_sola_image.changed?
      generated_image_file = Tempfile.new("mysola#{@my_sola_image.id}")
      generated_image.write(generated_image_file.path)
      
      @my_sola_image.generated_image = generated_image_file#File.open("mysola#{@my_sola_image.id}.jpg")
      @my_sola_image.save
    end
    
    send_data generated_image.to_blob, filename: "mysola.jpg", type: :jpg
  end

  def image_upload
    @my_sola_image = MySolaImage.create
    @my_sola_image.image = params[:file]
    @my_sola_image.save

    render :json => @my_sola_image
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

  def generate_image(image, statement, statement_variant)
    #p "generate image"
    m_image = Magick::Image.read(image.url(:original)).first.resize_to_fill!(1080, 1080)

    # blue overlay
    blue_overlay = Magick::Draw.new
    blue_overlay.fill = 'rgba(73, 156, 211, 0.1)'
    blue_overlay.rectangle(0, 0, 1080, 1080)
    blue_overlay.draw(m_image)

    # #MySola is [BLANK]
    if statement.present? && statement_variant == 'mysola_is'
      #p "#MySola is BlANK"
      
      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
      cursive_text.gravity = Magick::CenterGravity
      cursive_text.fill = '#ffffff'
      cursive_text_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
      cursive_text.pointsize = cursive_text_pointsize
      m_image.annotate(cursive_text, 1080, (1080 - 160), 0, 160, statement) 

      cursive_text_metrics = cursive_text.get_type_metrics(m_image, statement)
      ascent = cursive_text_metrics[:ascent]
      descent = cursive_text_metrics[:descent]
      height = cursive_text_metrics[:height]
      calculated_height = height + descent# + 160
      y_value = -(ascent - (statement =~ /[A-Z]/ ? 50 : 150)) / 2
      #p "height=#{height}, ascent=#{ascent}, descent=#{descent} calculated_height=#{calculated_height}, cursive_text_pointsize=#{cursive_text_pointsize}, #{y_value}"
      text = Magick::Draw.new
      m_image.annotate(text, 1080, 1080, 0, y_value, "#MySola is my") do
        text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
        text.gravity = Magick::CenterGravity
        text.pointsize = 70
        text.kerning = 2
        text.fill = '#ffffff'
      end      
    end   

    # I feel [BLANK] in #MySola
    if statement.present? && statement_variant == 'i_feel'
      #p "I feel BlANK"
      top_text = Magick::Draw.new
      m_image.annotate(top_text, 1080, 1080, 0, 300, "I feel") do
        top_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
        top_text.gravity = Magick::NorthGravity
        top_text.pointsize = 70
        top_text.kerning = 2
        top_text.fill = '#ffffff'
      end

      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
      cursive_text.gravity = Magick::CenterGravity
      cursive_text.fill = '#ffffff'
      cursive_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
      m_image.annotate(cursive_text, 1080, 1080 - 45, 0, 45, statement)
      
      bottom_text = Magick::Draw.new
      m_image.annotate(bottom_text, 1080, 1080, 0, 760, "in #MySola") do
        bottom_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
        bottom_text.gravity = Magick::NorthGravity
        bottom_text.pointsize = 70
        bottom_text.kerning = 2
        bottom_text.fill = '#ffffff'
      end
    end  

    # logo (200 x 119)
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/sola-logo.png')).first
    m_combined = m_image.composite(m_logo, 855, 935, Magick::OverCompositeOp)

    m_combined
  end

  # def generate_image(image, statement, statement_variant)
  #   #p "generate image"
  #   m_image = Magick::Image.read(image.url(:original)).first.resize_to_fill!(1080, 1080)

  #   # blue overlay
  #   blue_overlay = Magick::Draw.new
  #   blue_overlay.fill = 'rgba(73, 156, 211, 0.1)'
  #   blue_overlay.rectangle(0, 0, 1080, 1080)
  #   blue_overlay.draw(m_image)

  #   # #MySola is [BLANK]
  #   if statement.present? && statement_variant == 'mysola_is'
  #     #p "#MySola is BlANK"
      
  #     cursive_text = Magick::Draw.new
  #     cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
  #     cursive_text.gravity = Magick::CenterGravity
  #     cursive_text.fill = '#ffffff'
  #     cursive_text_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
  #     cursive_text.pointsize = cursive_text_pointsize
  #     m_image.annotate(cursive_text, 1080, (1080 - 160), 0, 160, statement) 

  #     cursive_text_metrics = cursive_text.get_type_metrics(m_image, statement)
  #     ascent = cursive_text_metrics[:ascent]
  #     descent = cursive_text_metrics[:descent]
  #     height = cursive_text_metrics[:height]
  #     calculated_height = height + descent# + 160
  #     y_value = -(ascent - (statement =~ /[A-Z]/ ? 50 : 150)) / 2
  #     #p "height=#{height}, ascent=#{ascent}, descent=#{descent} calculated_height=#{calculated_height}, cursive_text_pointsize=#{cursive_text_pointsize}, #{y_value}"
  #     text = Magick::Draw.new
  #     m_image.annotate(text, 1080, 1080, 0, y_value, "#MySola is my") do
  #       text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
  #       text.gravity = Magick::CenterGravity
  #       text.pointsize = 70
  #       text.kerning = 2
  #       text.fill = '#ffffff'
  #     end      
  #   end   

  #   # I feel [BLANK] in #MySola
  #   if statement.present? && statement_variant == 'i_feel'
  #     #p "I feel BlANK"
  #     top_text = Magick::Draw.new
  #     m_image.annotate(top_text, 1080, 1080, 0, 300, "I feel") do
  #       top_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
  #       top_text.gravity = Magick::NorthGravity
  #       top_text.pointsize = 70
  #       top_text.kerning = 2
  #       top_text.fill = '#ffffff'
  #     end

  #     cursive_text = Magick::Draw.new
  #     cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
  #     cursive_text.gravity = Magick::CenterGravity
  #     cursive_text.fill = '#ffffff'
  #     cursive_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
  #     m_image.annotate(cursive_text, 1080, 1080 - 45, 0, 45, statement)
      
  #     bottom_text = Magick::Draw.new
  #     m_image.annotate(bottom_text, 1080, 1080, 0, 760, "in #MySola") do
  #       bottom_text.font = "#{Rails.root}/lib/fonts/Lato-Medium.ttf"
  #       bottom_text.gravity = Magick::NorthGravity
  #       bottom_text.pointsize = 70
  #       bottom_text.kerning = 2
  #       bottom_text.fill = '#ffffff'
  #     end
  #   end  

  #   # logo (200 x 119)
  #   m_logo = Magick::Image.read(Rails.root.join('app/assets/images/sola-logo.png')).first
  #   m_combined = m_image.composite(m_logo, 855, 935, Magick::OverCompositeOp)

  #   m_combined
  # end

end
