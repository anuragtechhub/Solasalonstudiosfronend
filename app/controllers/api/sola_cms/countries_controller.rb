class Api::SolaCms::CountriesController < Api::SolaCms::ApiController

  #GET /countries
  def index
    @countries = params[:search].present? ? search_country_by_name : Country.order("#{field} #{order}")
    render json: { countries: @countries } and return if params[:all] == "true"
    @countries = paginate(@countries)
    render json:  { countries: @countries }.merge(meta: pagination_details(@countries))
  end

  private 

  def search_country_by_name
    Country.order("#{field} #{order}").search_by_name(params[:search])
  end
end
