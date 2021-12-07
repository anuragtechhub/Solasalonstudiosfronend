module Pro
  class Api::V1::ShortLinksController < ApiController

    def get
      short_link = ShortLink.where(:public_id => params[:public_id]).first

      if short_link
        ShortLink.increment_counter(:view_count, short_link.id)
        render :json => {:url => short_link.url}
      else
        render :json => {:url => nil}
      end
    end

  end
end