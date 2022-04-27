# frozen_string_literal: true

class NewsletterController < PublicWebsiteController
  skip_before_action :verify_authenticity_token, only: :sign_up

  def sign_up
    if request.post?
      if params[:email] && params[:email] =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        ::Hubspot::NewsletterJob.perform_async(params[:email], website_country)
        render json: { success: 'Thank you for subscribing!' }
      else
        render json: { error: 'Please enter a valid email address' }
      end
    end
  end

  private

    def website_country
      case I18n.locale.to_s
      when 'en'
        'United States'
      when 'en-CA'
        'Canada'
      when 'pt-BR'
        'Brazil'
      end
    end
end
