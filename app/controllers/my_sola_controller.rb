class MySolaController < PublicWebsiteController
  
  require 'RMagick'

  skip_before_filter :verify_authenticity_token, :only => [:image_upload]

  def index
    
  end

  def image
    @my_sola_image = MySolaImage.find(params[:id])
    m_image = Magick::Image.read(@my_sola_image.image.url(:instagram)).first

    # text
    text = Magick::Draw.new
    m_image.annotate(text, 1080, 100, 0, 300, "#MySola is my") do
      text.font = "#{Rails.root}/lib/fonts/Lato-Regular.ttf"
      text.gravity = Magick::NorthGravity
      text.pointsize = 100
      text.fill = '#ffffff'
      text.font_weight = Magick::BoldWeight
    end

    # logo
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/logo_white.png')).first
    m_combined = m_image.composite(m_logo, 860, 940, Magick::OverCompositeOp)

    send_data m_combined.to_blog, filename: "mysola.jpg", type: :jpg
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

  def s3_presigned_post
    presigned_post_params = {key: "#{SecureRandom.uuid}_${filename}", success_action_status: '201', acl: 'public-read', content_type: params[:content_type]}
    presigned_post = S3_MYSOLAIMAGES_BUCKET.presigned_post(presigned_post_params)
    
    render :json => {fields: presigned_post.fields, url: presigned_post.url}
  end

end
