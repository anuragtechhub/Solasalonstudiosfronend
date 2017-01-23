class MySolaController < PublicWebsiteController
  
  require 'RMagick'

  skip_before_filter :verify_authenticity_token, :only => [:image_upload]

  def index
    
  end

  def image
    @my_sola_image = MySolaImage.find(params[:id])
    @my_sola_image.statement = params[:statement]
    @my_sola_image.statement_variant = params[:statement_variant]
    @my_sola_image.save
    
    m_image = Magick::Image.read(@my_sola_image.image.url(:instagram)).first

    # #MySola is [BLANK]
    if params[:statement].present? && params[:statement_variant] == 'mysola_is'
      text = Magick::Draw.new
      m_image.annotate(text, 1080, 100, 0, 300, "#MySola is my") do
        text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        text.gravity = Magick::NorthGravity
        text.pointsize = 100
        text.fill = '#ffffff'
      end
      cursive_text = Magick::Draw.new
      cursive_pointsize = get_cursive_pointsize
      m_image.annotate(cursive_text, 1080, cursive_pointsize, 0, 450, params[:statement]) do
        cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
        cursive_text.gravity = Magick::NorthGravity
        cursive_text.pointsize = cursive_pointsize
        cursive_text.fill = '#ffffff'
      end 
    end   

    # I feel [BLANK] in #MySola
    if params[:statement].present? && params[:statement_variant] == 'i_feel'
      top_text = Magick::Draw.new
      m_image.annotate(top_text, 1080, 100, 0, 300, "I feel") do
        top_text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        top_text.gravity = Magick::NorthGravity
        top_text.pointsize = 100
        top_text.fill = '#ffffff'
      end
      cursive_text = Magick::Draw.new
      cursive_pointsize = get_cursive_pointsize
      m_image.annotate(cursive_text, 1080, cursive_pointsize, 0, 450, params[:statement]) do
        cursive_text.font = "#{Rails.root}/lib/fonts/Risthi.ttf"
        cursive_text.gravity = Magick::NorthGravity
        cursive_text.pointsize = cursive_pointsize
        cursive_text.fill = '#ffffff'
      end 
      bottom_text = Magick::Draw.new
      m_image.annotate(bottom_text, 1080, 100, 0, 800, "in #MySola") do
        bottom_text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        bottom_text.gravity = Magick::NorthGravity
        bottom_text.pointsize = 100
        bottom_text.fill = '#ffffff'
      end
    end  

    # logo
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/logo_white.png')).first
    m_combined = m_image.composite(m_logo, 860, 940, Magick::OverCompositeOp)

    send_data m_combined.to_blob, filename: "mysola.jpg", type: :jpg
  end

  def image_upload
    @my_sola_image = MySolaImage.create
    @my_sola_image.image = params[:file]
    @my_sola_image.save

    render :json => @my_sola_image
  end

  private

  def get_cursive_pointsize
    if params[:statement] && params[:statement].length > 18
      300
    elsif params[:statement] && params[:statement].length > 14 && params[:statement].length <= 18
      320
    elsif params[:statement] && params[:statement].length > 11 && params[:statement].length <= 14
      350
    else
      400
    end
  end

end
