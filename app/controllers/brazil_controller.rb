class BrazilController < PublicWebsiteController
  
  def sejasola
    if request.domain == 'solasalonstudios.ca' || request.domain == 'solasalonstudios.com' #|| request.domain == 'localhost'
      redirect_to :home
    end
    # elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
    #   I18n.locale = 'pt-BR'
    # else
    #   I18n.locale = 'en'
    # end
    render :layout => false
  end

end