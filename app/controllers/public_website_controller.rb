class PublicWebsiteController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'public_website'

  before_action :set_locale, :auth_if_test

  helper_method :all_locations, :all_states, :all_locations_msas, :all_states_json, :all_states_ca, :all_locations_ca_msas, :merge_solagenius_utm_params

  require 'uri'

  def merge_solagenius_utm_params(url)
    callback = Addressable::URI.parse(url.strip)
    callback.query_values = (callback.query_values || {}).merge({
      :utm_source => 'sola_salon',
      :utm_campaign => 'book_now_sp',
      :utm_medium => 'referral'
    })
    return callback.to_s
  rescue => e
    NewRelic::Agent.notice_error(e)
    Rollbar.error(e)
  end

  def auth_if_test
    if ENV['PASSWORD_PROTECT'] == 'YES' && !request.fullpath.include?('sejasola')
      authenticate_or_request_with_http_basic 'test' do |name, password|
        name == 'phish' && password == 'food'
      end
    end
  end

  def all_locations
    if I18n.locale == :en
      @all_locations ||= Location.open.where(country: 'US')
    elsif I18n.locale.to_s == 'en-CA'
      @all_locations ||= Location.open.where(country: 'CA')
    elsif I18n.locale.to_s == 'pt-BR'
      @all_locations ||= Location.open.where(country: 'BR')
    end
  end

  def all_states
    if I18n.locale == :en
      all_states_us
    else
      all_states_ca
    end
  end

  def all_states_us
    cache_key = "all_states/#{Location.maximum(:updated_at).to_i}"
    Rails.cache.fetch(cache_key) do
      Location.open.where(country: 'US').select("DISTINCT(state)").order(:state).uniq.pluck(:state).map(&:strip).uniq
    end
  end

  def all_states_ca
    cache_key = "all_states_ca/#{Location.maximum(:updated_at).to_i}"
    Rails.cache.fetch(cache_key) do
      Location.open.where(country: 'CA').select("DISTINCT(state)").order(:state).uniq.pluck(:state).map(&:strip).uniq
    end
  end

  def all_locations_msas
    cache_key = "all_locations_msas/#{Location.maximum(:updated_at).to_i}/#{Msa.maximum(:updated_at).to_i}"
    Rails.cache.fetch(cache_key) do
      sml = []

      all_locations.includes(:msa).group_by(&:msa_name).sort.each do |msa_name, locations|
        if msa_name
          sml << {option_type: 'msa', value: msa_name, filtered_by: locations.first.state.strip}
          locations.sort{|a, b| a.name.downcase <=> b.name.downcase}.each do |location|
            sml << {option_type: 'location', value: {id: location.id, name: location.name}, filtered_by: location.state.strip}
          end
        end
      end

      sml
    end
  end

  def all_locations_ca_msas
    cache_key = "all_locations_ca_msas/#{Location.maximum(:updated_at).to_i}/#{Msa.maximum(:updated_at).to_i}"
    Rails.cache.fetch(cache_key) do
      sml = []

      Location.open.includes(:msa).where(country: 'CA').group_by(&:msa_name).sort.each do |msa_name, locations|
        if msa_name
          sml << {option_type: 'msa', value: msa_name, filtered_by: locations.first.state.strip}
          locations.sort{|a, b| a.name.downcase <=> b.name.downcase}.each do |location|
            sml << {option_type: 'location', value: {id: location.id, name: location.name}, filtered_by: location.state.strip}
          end
        end
      end

      sml
    end
  end

  def state_names
    %w(Alaska Alabama Arkansas Arizona California Colorado Connecticut District\ of\ Columbia Delaware Florida Georgia Hawaii Iowa Idaho Illinois Indiana Kansas Kentucky Louisiana Massachusetts Maryland Maine Michigan Minnesota Missouri Mississippi Montana North\ Carolina North\ Dakota Nebraska New\ Hampshire New\ Jersey New\ Mexico Nevada New\ York Ohio Oklahoma Oregon Pennsylvania Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas Utah Virginia Vermont Washington Wisconsin West\ Virginia Wyoming)
  end

  def set_locale
    force_locale = params[:force_locale]
    return I18n.locale = force_locale if force_locale.present?
    
    if request.domain == 'solasalonstudios.ca' #|| request.domain == 'localhost'
      I18n.locale = 'en-CA'
    elsif request.domain == 'com.br' || request.domain == 'com.br/' #|| request.domain == 'localhost'
      I18n.locale = 'pt-BR'
    else
      I18n.locale = 'en'
    end
  end

  def banned_ip_addresses
    ENV['BANNED_IPS'].to_s.split(',')
  end
end

