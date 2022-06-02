class Api::SolaCms::SideMenuItemsController < Api::SolaCms::ApiController
  before_action :set_side_menu_item, only: %i[ show update destroy]

  #GET /side_menu_items
  def index
    @side_menu_items = SideMenuItem.all
    render json: @side_menu_items
  end

  #POST /side_menu_items
  def create
    @side_menu_item  = SideMenuItem.new(side_menu_item_params)
    @countries = Country.where(id: side_menu_item_params["country_ids"])
    @side_menu_item.countries << @countries
    if @side_menu_item.save
      render json: @side_menu_item
    else
      render json: {error: "Unable to Create Side Menu Items"}, status: 400
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
      render json: {error: "Unable to Update  Side Menu Items."}, status: 400
    end  
  end 

  #DELETE /side_menu_items/:id
  def destroy
    if @side_menu_item.destroy
      render json: {message: " Side Menu Items Successfully Deleted."}, status: 200
    else
      render json: {error: "Unable to Delete Side Menu Items."}, status: 400
    end
  end 

  private

  def set_side_menu_item
    @side_menu_item = SideMenuItem.find(params[:id])
  end

  def side_menu_item_params
    params.require(:side_menu_item).permit(:name, :action_link, :position, country_ids:[])
  end
end
