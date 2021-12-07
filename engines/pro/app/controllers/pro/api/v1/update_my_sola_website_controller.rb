module Pro
  class Api::V1::UpdateMySolaWebsiteController < ApiController

    def submit
      userable = get_user(params[:email])

      @update_my_sola_website = UpdateMySolaWebsite.where(:stylist_id => userable.id, :approved => false).order(:created_at => :desc).first

      existing = @update_my_sola_website ? true : false

      @update_my_sola_website = UpdateMySolaWebsite.find_by(:id => params[:update_my_sola_website][:id]) if params[:update_my_sola_website] && params[:update_my_sola_website][:id] && !@update_my_sola_website
      @update_my_sola_website = UpdateMySolaWebsite.new(:stylist_id => userable.id) unless @update_my_sola_website

      p "$$$ params[:update_my_sola_website]=#{params[:update_my_sola_website]}"
      p "-"
      p "-"
      p "-"
      p "$$$ params[:update_my_sola_website][:reserved]=#{params[:update_my_sola_website][:reserved]}"
      p "we have a UMSW, existing? #{existing}, #{@update_my_sola_website.image_1_url}"

      if request.post? || request.patch?
        @update_my_sola_website = assign_params(@update_my_sola_website, params[:update_my_sola_website], update_my_sola_website_params_permitted)

        build_testimonials_from_params(@update_my_sola_website, userable)

        # format phone number
        if @update_my_sola_website && @update_my_sola_website.phone_number.present?
          @update_my_sola_website.phone_number = formatPhoneNumber(@update_my_sola_website.phone_number)
        end

        if @update_my_sola_website.save
          p "umsw saved!!! #{@update_my_sola_website.image_1_url}"
          userable.reload
          render :json => {:success => 'Website update request saved! We will email you when your website changes are live.', :user => userable}
        else
          p "NOT SAVED #{@update_my_sola_website.errors.full_messages}"
          render :json => {:errors => @update_my_sola_website.errors.full_messages}
        end
      else
        render :json => {:error => true}
      end
    end

    private

    def formatPhoneNumber(s)
      return "" unless s
      s2 = (""+s).gsub(/\D/, '')
      m = s2.match(/^(\d{3})(\d{3})(\d{4})$/)
      return (!m) ? nil : "(" + m[1] + ") " + m[2] + "-" + m[3]
    end

    def assign_params(obj, params, names)
      p "ap #{obj}, #{params}, #{names}"
      return unless obj && params && names

      names.each do |name|
        p "assign params #{name}, #{params[name]}"
        obj.send("#{name.to_s}=", params[name.to_s].kind_of?(Array) ? params[name.to_s][0] : params[name.to_s])
      end

      obj
    end

    def build_testimonials_from_params(obj, user)
      if params[:update_my_sola_website][:testimonials]
        params[:update_my_sola_website][:testimonials].each do |testimonial_params|
          t_number = testimonial_params[0].split('_')[1].to_i
          t_params = testimonial_params[1]

          #p "t_number=#{t_number}"
          #p "t_params=#{t_params.inspect}"

          process_testimonial(obj, user, t_number, t_params);
        end
      end
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
      :email_address,]
    end

  end
end