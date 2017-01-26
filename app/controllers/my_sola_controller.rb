class MySolaController < PublicWebsiteController
  
  require 'RMagick'

  skip_before_filter :verify_authenticity_token

  def index
    
  end

  def show
    @my_sola_image = MySolaImage.find_by(:public_id => params[:id])
  end

  def image_preview
    # update and save MySolaImage with statement, variant, etc
    @my_sola_image = MySolaImage.find_by(:public_id => params[:id]) || MySolaImage.new
    @my_sola_image.name = params[:name]
    @my_sola_image.instagram_handle = params[:instagram_handle]
    @my_sola_image.statement = params[:statement]
    @my_sola_image.statement_variant = params[:statement_variant]
    @my_sola_image.save
    
    image = generate_image(@my_sola_image.image, params[:statement], params[:statement_variant])

    send_data image.to_blob, filename: "mysola.jpg", type: :jpg
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
    width = 980
    
    while width >= 980
      pointsize = pointsize - 20
      draw.pointsize = pointsize
      width = draw.get_type_metrics(image, text)[:width]
    end

    pointsize
  end

  def generate_image(image, statement, statement_variant)
    m_image = Magick::Image.read(image.url(:original)).first.resize_to_fill!(1080, 1080)

    # #MySola is [BLANK]
    if statement.present? && statement_variant == 'mysola_is'
      text = Magick::Draw.new
      m_image.annotate(text, 1080, 1080, 0, 250, "#MySola is my") do
        text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        text.gravity = Magick::NorthGravity
        text.pointsize = 60
        text.fill = '#ffffff'
      end
      
      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
      cursive_text.gravity = Magick::CenterGravity
      cursive_text.fill = '#ffffff'
      cursive_text.pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
      m_image.annotate(cursive_text, 1080, 1080, 0, 0, statement) 
    end   

    # I feel [BLANK] in #MySola
    if statement.present? && statement_variant == 'i_feel'
      top_text = Magick::Draw.new
      m_image.annotate(top_text, 1080, 1080, 0, 300, "I feel") do
        top_text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        top_text.gravity = Magick::NorthGravity
        top_text.pointsize = 100
        top_text.fill = '#ffffff'
      end

      cursive_text = Magick::Draw.new
      cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
      cursive_text.gravity = Magick::CenterGravity
      cursive_text.fill = '#ffffff'
      cursive_pointsize = calculate_cursive_pointsize(m_image, cursive_text, statement)
      m_image.annotate(cursive_text, 1080, 1080, 0, 0, statement)
      
      bottom_text = Magick::Draw.new
      m_image.annotate(bottom_text, 1080, 1080, 0, 800, "in #MySola") do
        bottom_text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        bottom_text.gravity = Magick::NorthGravity
        bottom_text.pointsize = 100
        bottom_text.fill = '#ffffff'
      end
    end  

    # logo
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/logo_white.png')).first
    m_combined = m_image.composite(m_logo, 860, 940, Magick::OverCompositeOp)

    m_combined
  end

end
