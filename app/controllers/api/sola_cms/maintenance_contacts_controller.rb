class Api::SolaCms::MaintenanceContactsController < Api::SolaCms::ApiController
  before_action :get_maintenance_contact, only: %i[ show update destroy]

  #GET /maintenance_contacts
  def index
    if params[:search].present?
      maintenance_contacts = ConnectMaintenanceContact.search_maintanence_contact(params[:search])
      maintenance_contacts = paginate(maintenance_contacts)
      render json:  { maintenance_contacts: maintenance_contacts }.merge(meta: pagination_details(maintenance_contacts))
    else  
      maintenance_contacts = ConnectMaintenanceContact.all
      maintenance_contacts = paginate(maintenance_contacts)
      render json: { maintenance_contacts: maintenance_contacts }.merge(meta: pagination_details(maintenance_contacts))
    end
  end

  #POST /maintenance_contacts
  def create
    @maintenance_contact  =  ConnectMaintenanceContact.new(maintenance_contact_params)
    if @maintenance_contact.save
      render json: @maintenance_contact
    else
      Rails.logger.info(@maintenance_contact.errors.messages)
      render json: {error: @maintenance_contact.errors.messages}, status: 400
    end 
  end 

  #GET /maintenance_contacts/:id
  def show
    render json: @maintenance_contact
  end 

  #PUT /maintenance_contacts/:id
  def update
    if @maintenance_contact.update(maintenance_contact_params)
      render json: {message: "Msa Successfully Updated."}, status: 200
    else
      Rails.logger.info(@maintenance_contact.errors.messages)
      render json: {error: @maintenance_contact.errors.messages}, status: 400
    end  
  end 

  #DELETE /maintenance_contacts/:id
  def destroy
    if @maintenance_contact&.destroy
      render json: {message: "Msa Successfully Deleted."}, status: 200
    else
      @maintenance_contact.errors.messages
      Rails.logger.info(@maintenance_contact.errors.messages)
    end
  end 

  private

  def get_maintenance_contact
    @maintenance_contact = ConnectMaintenanceContact.find(params[:id])
  end

  def maintenance_contact_params
    params.require(:connect_maintenance_contact).permit(:location_id, :contact_type, :contact_order, :contact_first_name, :contact_last_name, :contact_phone_number, :contact_email,  :contact_admin, :contact_preference, :request_routing_url)
  end
end
