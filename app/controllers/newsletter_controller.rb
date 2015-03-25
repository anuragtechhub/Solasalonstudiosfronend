class NewsletterController < PublicWebsiteController



  def sign_up
    if request.post?
      if params[:email] && params[:email] =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        gb = Gibbon::API.new('ddd6d7e431d3f8613c909e741cbcc948-us5')
        gb.lists.subscribe({:id => '09d9824082', :email => {:email => params[:email]}, :merge_vars => {}, :double_optin => false})
        render :json => {:success => 'Thank you for subscribing!'}
      else
        render :json => {:error => 'Please enter a valid email address'}
      end
    end
  end

end
