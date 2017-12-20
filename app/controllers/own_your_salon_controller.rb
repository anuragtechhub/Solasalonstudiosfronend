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

	# redirects for old urls

  def index
  	redirect_to :why_sola
  end

  def own_your_salon
  	redirect to :why_sola
  end

  def sola_pro
  	redirect_to :sola_pro
  end

  def solagenius
  	redirect_to :solagenius
  end

  def sola_sessions
  	redirect_to :sola_sessions
  end

  def studio_amenities
  	redirect_to :our_studios
  end

end