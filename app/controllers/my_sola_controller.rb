class MySolaController < PublicWebsiteController
  
  def index
  end

  def image
    
  end

  def s3_presigned_post
    presigned_post_params = {key: "#{SecureRandom.uuid}_${filename}", success_action_status: '201', acl: 'public-read', content_type: params[:content_type]}
    presigned_post = S3_MYSOLA_BUCKET.presigned_post(presigned_post_params)
    
    render :json => {fields: presigned_post.fields, url: presigned_post.url}
  end

end
