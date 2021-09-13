module Franchising
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    around_action :switch_locale

    helper_method :canadian_locale?

    def switch_locale(&action)
      locale = extract_locale_from_tld || I18n.default_locale
      I18n.with_locale(locale, &action)
    end

    # tld = top-level domain
    def extract_locale_from_tld
      parsed_locale = request.host.split('.').last
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end

    def canadian_locale?
      I18n.locale == :ca
    end

    def locale_str
      case
      when I18n.locale == :en
        'usa'
      else
        I18n.locale.to_s
      end
    end
  end
end
