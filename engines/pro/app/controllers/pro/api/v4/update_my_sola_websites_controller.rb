# frozen_string_literal: true

module Pro
  class Api::V4::UpdateMySolaWebsitesController < Api::V4::ApiController
    def create
      update_my_sola_website
      @update_my_sola_website.update!(update_params)
      render json: { success: I18n.t('update_my_sola_website_success'), user: current_user }
    end

    def walkins
      if params[:walkins_duration].blank? || params[:walkins_duration] == "0"
        disable_walkins
      else
        walkins_expiry = calculate_walkins_expiry
        if walkins_expiry >= DateTime.now && walkins_expiry <= (user_location_end_of_day || user_location_current_time)
          enable_walkins(walkins_expiry)
        else
          disable_walkins
          render status: 400, json: { error: ENV.fetch('WALKINS_ERROR')} and return
        end
      end

      current_user.save!
      respond_with(current_user, serializer: Api::V3::UserSerializer, root: 'user', location: nil)
    end

    private

      def update_params
        params.require(:update_my_sola_website)
          .permit(:name, :first_name, :phone_number, :business_name, :work_hours,
                  :biography, :booking_url, :reserved, :pinterest_url,
                  :website_url, :linkedin_url, :facebook_url,
                  :twitter_url, :instagram_url, :yelp_url, :tik_tok_url, :email_address,
                  :image_1_url, :image_2_url, :image_3_url, :image_4_url, :image_5_url,
                  :image_6_url, :image_7_url, :image_8_url, :image_9_url, :image_10_url,
                  :image_1, :image_2, :image_3, :image_4, :image_5,
                  :image_6, :image_7, :image_8, :image_9, :image_10,
                  :hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions,
                  :makeup, :microblading, :tanning, :waxing, :brows, :barber, :botox, :laser_hair_removal,
                  :threading, :permanent_makeup, :other_service, :hair_extensions, :email_address,
                  testimonial_1_attributes:  %i[id name region text],
                  testimonial_2_attributes:  %i[id name region text],
                  testimonial_3_attributes:  %i[id name region text],
                  testimonial_4_attributes:  %i[id name region text],
                  testimonial_5_attributes:  %i[id name region text],
                  testimonial_6_attributes:  %i[id name region text],
                  testimonial_7_attributes:  %i[id name region text],
                  testimonial_8_attributes:  %i[id name region text],
                  testimonial_9_attributes:  %i[id name region text],
                  testimonial_10_attributes: %i[id name region text]).tap do |permitted|
          permitted[:stylist_id] = current_user.id
          permitted[:image_1_url] = nil if permitted[:image_1].present?
          permitted[:image_2_url] = nil if permitted[:image_2].present?
          permitted[:image_3_url] = nil if permitted[:image_3].present?
          permitted[:image_4_url] = nil if permitted[:image_4].present?
          permitted[:image_5_url] = nil if permitted[:image_5].present?
          permitted[:image_6_url] = nil if permitted[:image_6].present?
          permitted[:image_7_url] = nil if permitted[:image_7].present?
          permitted[:image_8_url] = nil if permitted[:image_8].present?
          permitted[:image_9_url] = nil if permitted[:image_9].present?
          permitted[:image_10_url] = nil if permitted[:image_10].present?
          if permitted[:name].blank? && permitted[:first_name].present?
            permitted[:name] = permitted.delete(:first_name)
          end
        end
      end

      def update_my_sola_website
        @update_my_sola_website = UpdateMySolaWebsite
          .where(stylist_id: current_user.id, approved: false)
          .order(created_at: :desc)
          .first || UpdateMySolaWebsite.new(stylist_id: current_user.id)
      end

      def calculate_walkins_expiry
        return DateTime.now if current_user.location.blank?

        walkins_expiry = user_location_current_time + params[:walkins_duration].to_i.minutes

        if location_walkins_end_of_day.present? && walkins_expiry > user_location_end_of_day
          walkins_expiry = user_location_end_of_day
        end

        walkins_expiry
      end

      def user_location_current_time
        DateTime.now.in_time_zone(current_user.location.walkins_timezone_offset)
      end

      def user_location_end_of_day
        if location_walkins_end_of_day.present?
          user_location_current_time.change({
                                              hour: location_walkins_end_of_day.hour,
                                              min:  location_walkins_end_of_day.min
                                            })
        end
      end

      def location_walkins_end_of_day
        current_user.location&.walkins_end_of_day
      end

      def disable_walkins
        current_user.walkins = false
        current_user.walkins_expiry = nil
      end

      def enable_walkins(walkins_expiry)
        current_user.walkins = true
        current_user.walkins_expiry = walkins_expiry
      end
  end
end
