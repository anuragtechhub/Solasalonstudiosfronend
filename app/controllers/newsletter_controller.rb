class NewsletterController < PublicWebsiteController

  skip_before_filter :verify_authenticity_token, :only => :sign_up

  def sign_up
    if request.post?
      if params[:email] && params[:email] =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        # gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
        # gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})

        if ENV['HUBSPOT_API_KEY'].present?
          p "HUBSPOT API KEY IS PRESENT, lets sync.."

          Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

          Hubspot::Contact.create_or_update!([{
            email: params[:email], 
            hs_persona: 'persona_5',
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
    # shh...
    p "error newsletter sign up with hubspot #{e}"
  end
  # rescue Gibbon::MailChimpError => e
  #   render :json => {:success => 'Thank you for subscribing!'}
  # end

end
