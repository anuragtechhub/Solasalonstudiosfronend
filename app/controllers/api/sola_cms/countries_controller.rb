class Api::SolaCms::CountriesController < Api::SolaCms::ApiController

  #GET /countries
  def index
   @countries = Country.all
    if params[:search].present? 
      countries = Country.search_by_name(params[:search])
      countries = paginate(countries)
      render json:  { countries: countries }.merge(meta: pagination_details(countries))
    elsif params[:all] == "true"
      render json: { countries: @countries }
    else 
      countries = Country.all
      countries = paginate(countries)
      render json: { countries: countries }.merge(meta: pagination_details(countries))
    end
  end
end
