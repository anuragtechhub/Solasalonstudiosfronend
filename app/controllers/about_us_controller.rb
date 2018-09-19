class AboutUsController < PublicWebsiteController
  
  def index
    redirect_to :who_we_are
  end

  def leadership
    if I18n.locale.to_s == 'pt-BR'
      render 'leadership_br'
    end
  end

  def randall_clark
	end

  def rodrigo_miranda
  end

	def ben_jones
	end

	def jennie_wolff
	end

	def myrle_mcneal
	end

	def todd_neel
	end

  def our_story
  end

  def who_we_are
  end

  def why_sola
  end

end