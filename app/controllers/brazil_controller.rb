class BrazilController < PublicWebsiteController
  
  skip_before_filter :verify_authenticity_token

  def sejasola
    if request.domain == 'solasalonstudios.ca' || request.domain == 'solasalonstudios.com' #|| request.domain == 'localhost'
      redirect_to :home
    end

    if request.post?
      p "we gotta post! #{params[:nome]}, #{params[:email]}, #{params[:telefone]}"
      SejaSola.create(:nome => params[:nome], :email => params[:email], :telefone => params[:telefone], :area_de_atuacao => params[:area_de_atuacao])
      PublicWebsiteMailer.sejasola(params[:nome], params[:email], params[:telefone], params[:area_de_atuacao]).deliver
    end
    # elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
    #   I18n.locale = 'pt-BR'
    # else
    #   I18n.locale = 'en'
    # end
    render :layout => false
  end

  private

  def save_visit
    visit = Visit.new

    visit.uuid = request.uuid
    visit.ip_address = request.remote_ip
    visit.user_agent_string = request.env['HTTP_USER_AGENT']

    if visit.save
      return visit
    else
      return nil
    end
  end

end