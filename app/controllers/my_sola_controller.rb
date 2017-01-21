class MySolaController < PublicWebsiteController
  
  require 'RMagick'

  skip_before_filter :verify_authenticity_token, :only => [:image_upload]

  def index
    
  end

  def image

  end

  def image_upload
    @my_sola_image = MySolaImage.create
    #@my_sola_image.image = params[:file]

    m_image = Magick::Image.read(params[:file].open).first
    m_logo = Magick::Image.read(Rails.root.join('app/assets/images/logo_white.png')).first
    m_combined = m_image.composite(m_logo, 860, 940, Magick::OverCompositeOp)

    @my_sola_image.image = StringIO.open(m_combined.to_blob)
    @my_sola_image.save

    render :json => @my_sola_image
  end

  def s3_presigned_post
    presigned_post_params = {key: "#{SecureRandom.uuid}_${filename}", success_action_status: '201', acl: 'public-read', content_type: params[:content_type]}
    presigned_post = S3_MYSOLAIMAGES_BUCKET.presigned_post(presigned_post_params)
    
    render :json => {fields: presigned_post.fields, url: presigned_post.url}
  end

end
