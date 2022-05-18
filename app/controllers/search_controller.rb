# frozen_string_literal: true

class SearchController < PublicWebsiteController
  require 'uri'
  skip_before_action :verify_authenticity_token

  # TODO: refactor this piece of shit
  def results
    if params[:query].present?
      query_param = "%#{params[:query].downcase.gsub(/\s/, '%')}%"

      if /^[0-9]{5}(?:-[0-9]{4})?$/.match(params[:query])
        # zip code location
        @locations = Location.where(country: (I18n.locale == :en ? 'US' : 'CA')).open.near(params[:query], 20)
      else
        @locations = Location.where(country: (I18n.locale == :en ? 'US' : 'CA')).where(status: 'open').where('LOWER(name) = ?', params[:query].downcase)
        unless @locations.present?
          # p "yes exact match location #{exact_match_location.name}"
          locations1 = Location.open.near(params[:query].downcase).where(country: (I18n.locale == :en ? 'US' : 'CA'))
          locations2 = Location.open.where(country: (I18n.locale == :en ? 'US' : 'CA')).where('LOWER(state) LIKE ? OR LOWER(city) LIKE ? OR LOWER(name) LIKE ? OR LOWER(url_name) LIKE ?', query_param, query_param, query_param, query_param).where(country: (I18n.locale == :en ? 'US' : 'CA'))
          locations3 = Location.open.where(msa_id: Msa.where('LOWER(name) LIKE ?', query_param).select(:id).to_a).where(country: (I18n.locale == :en ? 'US' : 'CA'))

          @locations = locations1 + locations2 + locations3
        end
      end
      # preload stylists
      @locations = Location.where(id: @locations.map(&:id)).preload(:stylists).order(:name)

      # stylists
      if params[:stylists] != 'hidden'
        stylists_name = Stylist.where('website_name IS NULL OR website_name = ?', '').joins("INNER JOIN locations ON locations.id = stylists.location_id AND locations.country = '#{I18n.locale == :en ? 'US' : 'CA'}' AND locations.status = 'open'").where(status: 'open').where(reserved: false).where('LOWER(stylists.business_name) LIKE ? OR LOWER(stylists.name) LIKE ? OR LOWER(stylists.url_name) LIKE ?', query_param, query_param, query_param).where.not(location_id: nil)

        stylists_website_name = Stylist
          .where('website_name IS NOT NULL AND website_name != ?', '')
          .joins("INNER JOIN locations ON locations.id = stylists.location_id AND locations.country = '#{I18n.locale == :en ? 'US' : 'CA'}' AND locations.status = 'open'")
          .where(status: 'open')
          .where(reserved: false)
          .where('LOWER(stylists.business_name) LIKE ? OR LOWER(stylists.website_name) LIKE ? OR LOWER(stylists.url_name) LIKE ?', query_param, query_param, query_param)
          .where.not(location_id: nil)

        # service_type filter?
        # p "params[:service_type]=#{params[:service_type]}"
        if params[:service_type].present? && params[:service_type] != 'all_types'

          service_type_filter = if params[:service_type] == 'skincare'
                                  'skin = ?'
                                else
                                  "#{params[:service_type]} = ?"
                                end

          # hair, makeup, nails, skincare
          stylists_name = stylists_name.where(service_type_filter, true)
          stylists_website_name = stylists_website_name.where(service_type_filter, true)
        end

        @stylists = (stylists_name + stylists_website_name) # .flatten!

        if @stylists
          @stylists.uniq!
          @stylists.sort! { |a, b| a.name <=> b.name }
        end
      end

      # blog posts
      @posts = Blog.where(status: 'published')
        .where('LOWER(title) LIKE ? OR LOWER(body) LIKE ? OR LOWER(author) LIKE ?', query_param, query_param, query_param)
        .includes(:blog_categories)
        .order(publish_date: :desc)

      @results = @locations.size + @stylists.size + @posts.size
    end
  end
end
