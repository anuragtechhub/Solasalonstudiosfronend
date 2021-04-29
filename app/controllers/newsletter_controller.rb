class NewsletterController < PublicWebsiteController

  skip_before_filter :verify_authenticity_token, :only => :sign_up

  def sign_up
    if request.post?
      if params[:email] && params[:email] =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        ::Hubspot::NewsletterJob.perform_async(params[:email], website_country)
        render :json => {:success => 'Thank you for subscribing!'}
      else
        render :json => {:error => 'Please enter a valid email address'}
      end
    end
  end

  private

  def website_country
    if I18n.locale.to_s == 'en'
      'United States'
    elsif I18n.locale.to_s == 'en-CA'
      'Canada'
    elsif I18n.locale.to_s == 'pt-BR'
      'Brazil'
    end
  end
end
