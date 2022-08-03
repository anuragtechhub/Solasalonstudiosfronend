class Api::SolaCms::UpdateMySolaWebsitesController < Api::SolaCms::ApiController
  before_action :get_sola_data, only: %i[ show update destroy]

  def index
    sola_websites = if params[:status] == 'pending'
                      UpdateMySolaWebsite.order("#{field} #{order}").pending
                    elsif params[:status] == 'approved'
                      UpdateMySolaWebsite.order("#{field} #{order}").approved
                    else
                      return render json: { message: "Record Not Found."}  
                    end
      sola_websites = sola_websites.search_website(params[:search]) if params[:search].present? 
      sola_websites = paginate(sola_websites)
    render json: { sola_websites: sola_websites }.merge(meta: pagination_details(sola_websites))
  end

  def show
    render json: @sola_website
  end

  def update
    if @sola_website.update(sola_website_params)
      Pro::AppMailer.stylist_website_update_request_submitted(@sola_website).deliver
      render json: { message: "Sola Website Updated successfully." }, status: 200
    else
      Rails.logger.info(@sola_website.errors.messages)
      render json: { message: @sola_website.errors.messages}
    end  
  end

  def destroy
    if @sola_website&.destroy
      render json: { message: "deleted successfully."}
    else
      render json: {errors: format_activerecord_errors(@sola_website.errors) }, status: 400
    end  
  end
  
  private

  def get_sola_data
    @sola_website = UpdateMySolaWebsite.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @sola_website.present?
  end

  def search_sola_data
  
  end 

  def sola_website_params
    params.permit(:name, 
      :biography, 
      :phone_number,
      :business_name,
      :work_hours,
      :hair,
      :skin,
      :nails,
      :massage,
      :teeth_whitening,
      :eyelash_extensions,
      :makeup,
      :tanning,
      :waxing,
      :brows,
      :website_url,
      :booking_url,
      :pinterest_url,
      :facebook_url,
      :twitter_url,
      :instagram_url,
      :yelp_url,
      :laser_hair_removal,
      :threading,
      :permanent_makeup,
      :other_service,
      :google_plus_url,
      :linkedin_url,
      :hair_extensions,
      :email_address,
      :stylist_id,
      :approved,
      :image_1,
      :image_2,
      :image_3,
      :image_4,
      :image_5,
      :image_6,
      :image_7,
      :image_8,
      :image_9,
      :image_10,
      :microblading,
      :delete_image_1,
      :delete_image_2,
      :delete_image_3,
      :delete_image_4,
      :delete_image_5,
      :delete_image_6,
      :delete_image_7,
      :delete_image_8,
      :delete_image_9,
      :delete_image_10,
      :reserved,
      :botox,
      :tik_tok_url,
      :barber,
      testimonial_1_attributes: [:name, :text, :region],
      testimonial_2_attributes: [:name, :text, :region],
      testimonial_3_attributes: [:name, :text, :region],
      testimonial_4_attributes: [:name, :text, :region],
      testimonial_5_attributes: [:name, :text, :region],
      testimonial_6_attributes: [:name, :text, :region],
      testimonial_7_attributes: [:name, :text, :region],
      testimonial_8_attributes: [:name, :text, :region],
      testimonial_9_attributes: [:name, :text, :region],
      testimonial_10_attributes: [:name, :text, :region]
      )
  end
end