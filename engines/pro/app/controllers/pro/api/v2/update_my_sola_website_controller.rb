# frozen_string_literal: true

module Pro
  class Api::V2::UpdateMySolaWebsiteController < ApiController
    def submit
      userable = get_user(params[:email])

      @update_my_sola_website = UpdateMySolaWebsite.where(stylist_id: userable.id, approved: false).order(created_at: :desc).first

      existing = @update_my_sola_website ? true : false

      @update_my_sola_website = UpdateMySolaWebsite.find_by(id: params[:update_my_sola_website][:id]) if params[:update_my_sola_website] && params[:update_my_sola_website][:id] && !@update_my_sola_website
      @update_my_sola_website ||= UpdateMySolaWebsite.new(stylist_id: userable.id)

      p "we have a UMSW, existing? #{existing}, #{@update_my_sola_website.image_1_url}"

      if request.post? || request.patch?
        @update_my_sola_website = assign_params(@update_my_sola_website, params[:update_my_sola_website], update_my_sola_website_params_permitted)

        build_testimonials_from_params(@update_my_sola_website, userable)

        if @update_my_sola_website.save
          p "umsw saved!!! #{@update_my_sola_website.image_1_url}"
          userable.reload
          render json: { success: I18n.t('update_my_sola_website_success'), user: userable }
        else
          p "NOT SAVED #{@update_my_sola_website.errors.full_messages}"
          render json: { errors: @update_my_sola_website.errors.full_messages }
        end
      else
        render json: { error: true }
      end
    end

    def walkins
      if request.post?
        userable = get_user(params[:email])

        if params[:walkins_duration].blank?
          # turn off walkins
          p 'turn off walkins'
          userable.walkins = false
          userable.walkins_expiry = nil
        else
          # handle expiry time/duration
          p 'handle expiry time/duration'
          walkins_expiry = calculate_walkins_expiry(userable)

          p "walkins_expiry=#{walkins_expiry}"
          p "userable.location.walkins_timezone_offset=#{userable.location.walkins_timezone_offset}"
          max_expiry = DateTime.now.in_time_zone(userable.location.walkins_timezone_offset)
          p "max_expiry before=#{max_expiry}"

          if userable.location&.walkins_end_of_day.present?
            max_expiry = max_expiry.change({ hour: userable.location.walkins_end_of_day.hour, min: userable.location.walkins_end_of_day.min })
            p "max_expiry after=#{max_expiry}"
          end

          if walkins_expiry >= DateTime.now && walkins_expiry <= max_expiry
            p 'later than now, less than max - set expiry and walkins true!'
            userable.walkins = true
            userable.walkins_expiry = walkins_expiry
          else
            p 'greater than max - expiry NIL walkins FALSE'
            userable.walkins = false
            userable.walkins_expiry = nil
          end
        end

        if userable.save
          p 'updated walkins!'
          render json: { success: I18n.t('walkins_update_success'), user: userable }
        else
          p "did not update walkins! #{userable.errors.inspect}"
          render json: { errors: I18n.t('something_went_wrong') }
        end
      else
        render json: { error: I18n.t('something_went_wrong') }
      end
    end

    private

      def assign_params(obj, params, names)
        return unless obj && params && names

        names.each do |name|
          p "assign params #{name}, #{params[name]}"
          obj.send("#{name}=", params[name.to_s].is_a?(Array) ? params[name.to_s][0] : params[name.to_s])
        end

        obj
      end

      def build_testimonials_from_params(obj, user)
        params[:update_my_sola_website][:testimonials]&.each do |testimonial_params|
          t_number = testimonial_params[0].split('_')[1].to_i
          t_params = testimonial_params[1]

          # p "t_number=#{t_number}"
          # p "t_params=#{t_params.inspect}"

          process_testimonial(obj, user, t_number, t_params)
        end
      end

      def calculate_walkins_expiry(user)
        return DateTime.now unless user&.location

        # location_end_offset = DateTime.now.in_time_zone(user.location.walkins_timezone_offset).utc_offset / 60 / 60 * 100
        # if location_end_offset.abs < 1000
        #   if location_end_offset < 0
        #     location_end_offset = '-0' + location_end_offset.abs.to_s
        #   else
        #     location_end_offset = '+0' + location_end_offset.abs.to_s
        #   end
        # else
        #   location_end_offset = '+' + location_end_offset.abs.to_s
        # end

        # p

        walkins_expiry = DateTime.now.in_time_zone(user.location.walkins_timezone_offset)

        if params[:walkins_duration].present?
          walkins_expiry += params[:walkins_duration].to_i.minutes
        end

        p "walkins_expiry=#{walkins_expiry}"

        if user.location.walkins_end_of_day
          walkins_end_of_day = user.location.walkins_end_of_day.to_s(:time).split(':')
          p "walkins_end_of_day=#{walkins_end_of_day}, hour=#{walkins_end_of_day[0].to_i}, min:#{walkins_end_of_day[1].to_i}"

          # p "location_end_offset=#{location_end_offset}"
          location_end = DateTime.now.in_time_zone(user.location.walkins_timezone_offset).change({ hour: walkins_end_of_day[0].to_i, min: walkins_end_of_day[1].to_i }) # .change(:offset => location_end_offset)
          p "location_end=#{location_end}"
          if location_end < walkins_expiry
            p 'setting to location end'
            walkins_expiry = location_end
          end
        end

        walkins_expiry
      end

      def process_testimonial(obj, user, number, params)
        p "process_testimonials=#{params}"
        if user.send("testimonial_#{number}").present? && user.send("testimonial_#{number}").name == params[:name] && user.send("testimonial_#{number}").text == params[:text] && user.send("testimonial_#{number}").region == params[:region]
          obj.send("testimonial_id_#{number}=", user.send("testimonial_id_#{number}"))
        else
          testimonial = params[:id] ? Testimonial.find(params[:id]) : Testimonial.new
          testimonial.name = params[:name]
          testimonial.text = params[:text]
          testimonial.region = params[:region]
          testimonial.save
          obj.send("testimonial_id_#{number}=", testimonial.id)
        end
      end

      def update_my_sola_website_params_permitted
        [:name,
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
         :microblading,
         :tanning,
         :waxing,
         :brows,
         :barber,
         :botox,
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
         :reserved,
         # :testimonial_id_1,
         # :testimonial_id_2,
         # :testimonial_id_3,
         # :testimonial_id_4,
         # :testimonial_id_5,
         # :testimonial_id_6,
         # :testimonial_id_7,
         # :testimonial_id_8,
         # :testimonial_id_9,
         # :testimonial_id_10,
         :image_1_url,
         :image_2_url,
         :image_3_url,
         :image_4_url,
         :image_5_url,
         :image_6_url,
         :image_7_url,
         :image_8_url,
         :image_9_url,
         :image_10_url,
         :email_address]
      end
  end
end
