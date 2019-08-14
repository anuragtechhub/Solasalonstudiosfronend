class OwnYourSalonController < PublicWebsiteController
  
	def our_studios
	end

	def sola_pro
	end

	def sola_sessions
	end

	def solagenius
	end

	def why_sola
	end

  def why_sola_2
  end

	# redirects for old urls

  def index
  	redirect_to :why_sola, :status => 301
  end

  def own_your_salon
  	redirect to :why_sola, :status => 301
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