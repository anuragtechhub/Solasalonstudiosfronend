# frozen_string_literal: true

class Pro::RedirectController < Pro::ApplicationController
  skip_before_filter :authorize

  def short_link
    short_link = ShortLink.find_by(public_id: params[:public_id]) if params[:public_id]

    if short_link && short_link.url.present?
      ShortLink.increment_counter(:view_count, short_link.id)
      redirect_to short_link.url
    else
      redirect_to 'https://www.solaprofessional.com'
    end
  end
end
