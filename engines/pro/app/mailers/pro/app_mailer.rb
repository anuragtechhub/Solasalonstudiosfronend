module Pro
  class AppMailer < ActionMailer::Base
    default from: "Sola Pro <professional@solasalonstudios.com>"

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.app_mailer.forgot_password.subject
    #
    def forgot_password(reset_password)
      @reset_password = reset_password
      mail :to => reset_password.email, :subject => t(:forgot_password_reset_instructions)
    end

    def get_featured_by_sola(get_featured)
      @get_featured = get_featured
      mail :to => 'jennie@solasalonstudios.com', :subject => 'Get Featured by Sola - Form Submission'
    end

    def new_class_or_event(sola_class)
      @sola_class = sola_class
      mail :to => 'melissa@solasalonstudios.com', :subject => 'New Sola Pro Class/Event Created'
    end

    def stylist_website_update_request_submitted(update_my_sola_website)
      if update_my_sola_website
        @update_my_sola_website = update_my_sola_website
        if @update_my_sola_website && @update_my_sola_website.stylist && @update_my_sola_website.stylist.location && @update_my_sola_website.stylist.location.admin && @update_my_sola_website.stylist.location.admin.email_address
          location = @update_my_sola_website.stylist.location
          to = location.emails_for_stylist_website_approvals.presence || location.admin.email_address
          mail(to: to, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: t(:update_my_sola_website_request_from, {:name => @update_my_sola_website.stylist.name}))
        end
      end
    end
  end
end
