# frozen_string_literal: true

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

  def our_studios; end

  def sola_pro; end

  def sola_sessions
    redirect_to 'https://www.eventbrite.com/e/the-sola-sessions-tickets-233815357027', status: :temporary_redirect if ENV.fetch('WEB_HOST', nil) == 'www.solasalonstudios.com'
    @body_class = 'sola-sessions'
  end

  def solagenius; end

  def why_sola
    @body_class = 'why-sola'
  end

  # redirects for old urls

  def index
    redirect_to :why_sola, status: :moved_permanently
  end

  def own_your_salon
    redirect_to :why_sola, status: :moved_permanently
  end

  def old_sola_pro
    redirect_to :sola_pro, status: :moved_permanently
  end

  def old_solagenius
    redirect_to :solagenius, status: :moved_permanently
  end

  def old_sola_sessions
    redirect_to :sola_sessions, status: :moved_permanently
  end

  def studio_amenities
    redirect_to :our_studios, status: :moved_permanently
  end
end
