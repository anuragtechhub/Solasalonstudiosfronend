class OwnYourSalonController < PublicWebsiteController

  def contact_form_success
    @contact_form_success = true
    @success = I18n.t('contact_form_success')
    render 'why_sola'
  end

  def contact_form_success_2
    @contact_form_success = true
    @success = I18n.t('contact_form_success')
    render 'why_sola_2'
  end

	def our_studios
	end

	def sola_pro
	end

	def sola_sessions
    redirect_to 'https://www.facebook.com/solasalons/videos/1286034231819762', status: 307
    @body_class = 'sola-sessions'
	end

	def solagenius
	end

	def why_sola
    @body_class = 'why-sola'
	end

	# redirects for old urls

  def index
  	redirect_to :why_sola, :status => 301
  end

  def own_your_salon
  	redirect_to :why_sola, :status => 301
  end

  def old_sola_pro
  	redirect_to :sola_pro, :status => 301
  end

  def old_solagenius
  	redirect_to :solagenius, :status => 301
  end

  def old_sola_sessions
  	redirect_to :sola_sessions, :status => 301
  end

  def studio_amenities
  	redirect_to :our_studios, :status => 301
  end

end
