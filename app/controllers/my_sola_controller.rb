class MySolaController < PublicWebsiteController
  
  require 'RMagick'

  skip_before_filter :verify_authenticity_token, :only => [:image_upload]

  def index
    
  end

  def image
    @my_sola_image = MySolaImage.find(params[:id])
    m_image = Magick::Image.read(@my_sola_image.image.url(:instagram)).first

    # #MySola is [BLANK]
    if params[:statement].present? && params[:statement_variant] == 'mysola_is'
      p "DOING MYSOLA IS"
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
        cursive_text.font = "#{Rails.root}/lib/fonts/Pacifico-Regular.ttf"
        cursive_text.gravity = Magick::NorthGravity
        cursive_text.pointsize = cursive_pointsize
        cursive_text.fill = '#ffffff'
      end 
    end   

    # I feel [BLANK] in #MySola
    if params[:statement].present? && params[:statement_variant] == 'i_feel'
      p "DOING I FEEL"
      # MySola is [BLANK]
      text = Magick::Draw.new
      m_image.annotate(text, 1080, 100, 0, 300, "I feel") do
        text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
        text.gravity = Magick::NorthGravity
        text.pointsize = 100
        text.fill = '#ffffff'
      end
      cursive_text = Magick::Draw.new
      cursive_pointsize = get_cursive_pointsize
      m_image.annotate(cursive_text, 1080, cursive_pointsize, 0, 450, params[:statement]) do
        cursive_text.font = "#{Rails.root}/lib/fonts/Pacifico-Regular.ttf"
        cursive_text.gravity = Magick::NorthGravity
        cursive_text.pointsize = cursive_pointsize
        cursive_text.fill = '#ffffff'
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

    # m_image = Magick::Image.read(params[:file].open).first.resize_to_fill!(1080, 1080)

    # # text
    # text = Magick::Draw.new
    # m_image.annotate(text, 1080, 100, 0, 300, "#MySola is my") do
    #   text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
    #   text.gravity = Magick::NorthGravity
    #   text.pointsize = 100
    #   text.fill = '#ffffff'
    #   text.font_weight = Magick::BoldWeight
    # end

    # # logo
    # m_logo = Magick::Image.read(Rails.root.join('app/assets/images/logo_white.png')).first
    # m_combined = m_image.composite(m_logo, 860, 940, Magick::OverCompositeOp)


    # @my_sola_image.image = StringIO.open(m_combined.to_blob)
    @my_sola_image.save

    render :json => @my_sola_image
  end

  private

  def get_cursive_pointsize
    if params[:statement] && params[:statement].length > 18
      100
    elsif params[:statement] && params[:statement].length > 14 && params[:statement].length <= 18
      120
    elsif params[:statement] && params[:statement].length > 11 && params[:statement].length <= 14
      150
    else
      200
    end
  end

end
