# frozen_string_literal: true

class AboutUsController < PublicWebsiteController
  def index
    if I18n.locale.to_s != 'pt-BR'
      redirect_to :who_we_are, status: :moved_permanently
    end
  end

  def leadership
    if I18n.locale.to_s == 'pt-BR'
      render 'leadership_br'
    else
      redirect_to :who_we_are, status: :moved_permanently
    end
  end

  def randall_clark
    redirect_to :leadership, status: :moved_permanently
  end

  def rodrigo_miranda; end

  def ben_jones; end

  def jennie_wolff; end

  def myrle_mcneal; end

  def todd_neel; end

  def our_story; end

  def who_we_are; end

  def why_sola; end
end
