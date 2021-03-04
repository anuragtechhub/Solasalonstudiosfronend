class TestimonialsController < PublicWebsiteController
  def index
  	if I18n.locale.to_s == 'en-CA'
  		render 'index_ca'
    elsif
    I18n.locale.to_s == 'pt-BR'
      render 'index_br'
  	end
  end
end
