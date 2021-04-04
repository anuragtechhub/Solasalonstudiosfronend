class NewsletterController < PublicWebsiteController

  skip_before_filter :verify_authenticity_token, :only => :sign_up

  def sign_up
    if request.post?
      if params[:email] && params[:email] =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        # gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
        # gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})

        if ENV['HUBSPOT_API_KEY'].present?
          p "HUBSPOT API KEY IS PRESENT, lets sync...country=#{website_country}"

          Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

          Hubspot::Contact.create_or_update!([{
            email: params[:email],
            hs_persona: 'persona_5',
            country: website_country
          }])
        else
          p "No HUBSPOT API KEY, no sync"
        end

        render :json => {:success => 'Thank you for subscribing!'}
      else
        render :json => {:error => 'Please enter a valid email address'}
      end
    end
  rescue => e
    NewRelic::Agent.notice_error(e)
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
