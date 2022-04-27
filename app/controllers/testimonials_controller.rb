# frozen_string_literal: true

class TestimonialsController < PublicWebsiteController
  def index
    case I18n.locale.to_s
    when 'en-CA'
      render 'index_ca'
    when 'pt-BR'
      render 'index_br'
    end
  end
end
