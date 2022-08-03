class Api::SolaCms::SideMenuItemsController < Api::SolaCms::ApiController
  before_action :set_side_menu_item, only: %i[ show update destroy]
  
  #GET /side_menu_items
  def index
    @side_menu_items = params[:search].present? ? search_side_menu_items : SideMenuItem.order("#{field} #{order}")
    @side_menu_items = paginate(@side_menu_items)
    render json:  { side_menu_items: @side_menu_items }.merge(meta: pagination_details(@side_menu_items)), status: 200
  end

  #POST /side_menu_items
  def create
    @side_menu_item  = SideMenuItem.new(side_menu_item_params)
    @countries = Country.where(id: side_menu_item_params["country_ids"])
    @side_menu_item.countries << @countries
    if @side_menu_item.save
      render json: @side_menu_item, status: 200
    else
      Rails.logger.error(@side_menu_item.errors)
      render json: {error: @side_menu_item.errors}, status: 400
    end 
  end 

  #GET /side_menu_items/:id
  def show
    render json: @side_menu_item
  end 

  #PUT /side_menu_items/:id
  def update
    if @side_menu_item.update(side_menu_item_params)
      render json: {message: " Side Menu Items Successfully Updated."}, status: 200
    else
      Rails.logger.error(@side_menu_item.errors)
      render json: {error: @side_menu_item.errors}, status: 400
    end  
  end 

  #DELETE /side_menu_items/:id
  def destroy
    if @side_menu_item&.destroy
      render json: {message: " Side Menu Items Successfully Deleted."}, status: 200
    else
      Rails.logger.error(@side_menu_item.errors)
      render json: {errors: format_activerecord_errors(@side_menu_item.errors) }, status: 400
    end
  end 

  private

  def set_side_menu_item
    @side_menu_item = SideMenuItem.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 404 unless @side_menu_item.present?
  end

  def side_menu_item_params
    params.require(:side_menu_item).permit(:name, :action_link, :position, country_ids:[])
  end

  def search_side_menu_items
    SideMenuItem.order("#{field} #{order}").search_by_side_menu_items(params[:search])
  end
end
