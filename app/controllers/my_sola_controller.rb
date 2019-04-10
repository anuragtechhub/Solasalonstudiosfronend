class MySolaController < PublicWebsiteController
  
  require 'RMagick'
  #require 'FileUtils'

  skip_before_filter :verify_authenticity_token

  def index
    last_approved_my_sola_image = MySolaImage.select(:updated_at).order(:updated_at => :desc).first
    cache_key = "/my-sola/approved-images?last_approved_at=#{last_approved_my_sola_image.updated_at}"

    @gallery_images = Rails.cache.fetch(cache_key) do   
      pre_2019 = MySolaImage.where("approved = ? AND created_at < ?", true, Date.new(2019, 1, 1))
      post_2019 = MySolaImage.where("approved = ? AND created_at >= ?", true, Date.new(2019, 1, 1))

      (post_2019.to_a + pre_2019.to_a).to_json
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
    blue_overlay.fill = 'rgba(0, 0, 0, 0.15)'
    blue_overlay.rectangle(0, 0, 1080, 1080)
    blue_overlay.draw(m_image)

    # #MySola is my [BLANK]
    if statement.present? && statement_variant == 'mysola_is'
      #p "#MySola is my BlANK"
      
      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/ChaletNewYorkSixty.ttf"
      cursive_text.gravity = Magick::NorthWestGravity
      cursive_text.fill = '#ffffff'
      cursive_text_pointsize = 75#calculate_cursive_pointsize(m_image, cursive_text, statement)
      cursive_text.pointsize = cursive_text_pointsize
      cursive_text.kerning = -2
      #m_image.annotate(cursive_text, 1080, 1080, 540 + 7, 540 + 60, statement) 

      statement_rows = []
      statement.split(" ").each do |word|
        #p "word=#{word}"
        last_statement_row = statement_rows[statement_rows.length - 1]
        if word.length >= 14 || (last_statement_row && (last_statement_row.length >= 14 || (last_statement_row + ' ' + word).length >= 14))
          statement_rows << word
        else
          if last_statement_row
            statement_rows[statement_rows.length - 1] += ' ' + word
          else
            statement_rows << word
          end
        end
      end

      #p "statement_rows=#{statement_rows}"
      cursive_text_y = 540 + 80
      statement_rows.each_with_index do |statement_row_text, idx|
        m_image.annotate(cursive_text, 1080, 1080, 515, cursive_text_y + (idx * 73), statement_row_text) 
      end

      #statement.chars.each_slice(2).map(&:join)

      cursive_text_metrics = cursive_text.get_type_metrics(m_image, statement)
      ascent = cursive_text_metrics[:ascent]
      descent = cursive_text_metrics[:descent]
      height = cursive_text_metrics[:height]
      calculated_height = height + descent# + 160
      y_value = -(ascent - (statement =~ /[A-Z]/ ? 50 : 150)) / 2

      #p "height=#{height}, ascent=#{ascent}, descent=#{descent} calculated_height=#{calculated_height}, cursive_text_pointsize=#{cursive_text_pointsize}, #{y_value}"

      text = Magick::Draw.new
      m_image.annotate(text, 1080, 1080, 400, 540 + 80, "my") do
        text.font = "#{Rails.root}/lib/fonts/ChaletParisSixty.ttf"
        text.gravity = Magick::NorthWestGravity
        text.pointsize = 75
        text.kerning = -2
        text.fill = '#ffffff'
      end      
    end   

    # I feel [BLANK] in #MySola
    if statement.present? && statement_variant == 'i_feel'
      #p "I feel BlANK"
      top_text = Magick::Draw.new
      m_image.annotate(top_text, 1080, 1080, 60, 540 - 140, "I feel") do
        top_text.font = "#{Rails.root}/lib/fonts/ChaletParisSixty.ttf"
        top_text.gravity = Magick::NorthWestGravity
        top_text.pointsize = 75
        top_text.kerning = -2
        top_text.fill = '#ffffff'
      end

      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/ChaletNewYorkSixty.ttf"
      cursive_text.gravity = Magick::NorthWestGravity
      cursive_text.fill = '#ffffff'
      cursive_text.kerning = -2
      cursive_text.pointsize = 75#calculate_cursive_pointsize(m_image, cursive_text, statement)
      m_image.annotate(cursive_text, 1080, 1080, 223, 540 - 140, statement)
      cursive_text_width = cursive_text.get_type_metrics(statement)[:width]
      #p "cursive_text_width=#{cursive_text_width}"
      bottom_text = Magick::Draw.new
      m_image.annotate(bottom_text, 1080, 1080, cursive_text_width + 237, 540 - 138, "in") do
        bottom_text.font = "#{Rails.root}/lib/fonts/ChaletParisSixty.ttf"
        bottom_text.gravity = Magick::NorthWestGravity
        bottom_text.pointsize = 75
        bottom_text.kerning = -2
        bottom_text.fill = '#ffffff'
      end
    end  

    # big cursive #MySola text
    if statement.present? && statement_variant == 'mysola_is'
      my_sola_is_image = Magick::Image.read(Rails.root.join('app/assets/images/my_sola_is.png')).first
      m_combined = m_image.composite(my_sola_is_image, 80, 540 - (262 / 2) - 80, Magick::OverCompositeOp)
    elsif statement.present? && statement_variant == 'i_feel'
      my_sola_image = Magick::Image.read(Rails.root.join('app/assets/images/my_sola.png')).first
      m_combined = m_image.composite(my_sola_image, 1080 - 744 - 55, 540 - (262 / 2) + 75, Magick::OverCompositeOp)
    end

    # s mark logo (187 x 186)
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/s_logo.png')).first
    if m_combined
      m_combined = m_combined.composite(m_logo, 939, 945, Magick::OverCompositeOp)
    else
      m_combined = m_image.composite(m_logo, 939, 945, Magick::OverCompositeOp)
    end    

    # logo (200 x 119)
    # m_logo = Magick::Image.read(Rails.root.join('app/assets/images/sola-logo.png')).first
    # if m_combined
    #   m_combined = m_combined.composite(m_logo, 855, 935, Magick::OverCompositeOp)
    # else
    #   m_combined = m_image.composite(m_logo, 855, 935, Magick::OverCompositeOp)
    # end

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
