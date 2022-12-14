# frozen_string_literal: true

class SessionsController < PublicWebsiteController
  def index
    # redirect_to :home
    # render 'orange_county'
    redirect_to :sola_sessions, status: :moved_permanently
  end

  def chicago; end

  def dallas; end

  def dc; end

  def denver; end

  def minneapolis; end

  def nashville; end

  def orange_county; end

  def charlotte; end

  def san_diego; end

  def san_jose; end

  def west_palm_beach; end
end
