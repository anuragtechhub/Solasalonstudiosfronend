class Api::SolaCms::MaintenanceContactsController < Api::SolaCms::ApiController
  before_action :get_maintenance_contact, only: %i[ show update destroy]

  #GET /maintenance_contacts
  def index
    @maintenance_contacts = params[:search].present? ? search_maintenance_contact : ConnectMaintenanceContact.order("#{field} #{order}")
    @maintenance_contacts = paginate(@maintenance_contacts)
    render json:  { maintenance_contacts: @maintenance_contacts }.merge(meta: pagination_details(@maintenance_contacts))
  end

  #POST /maintenance_contacts
  def create
    @maintenance_contact  =  ConnectMaintenanceContact.new(maintenance_contact_params)
    if @maintenance_contact.save
      render json: @maintenance_contact, status: 200
    else
      Rails.logger.error(@maintenance_contact.errors.messages)
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
      Rails.logger.error(@maintenance_contact.errors.messages)
      render json: {error: @maintenance_contact.errors.messages}, status: 400
    end  
  end 

  #DELETE /maintenance_contacts/:id
  def destroy
    if @maintenance_contact&.destroy
      render json: {message: "Msa Successfully Deleted."}, status: 200
    else
      @maintenance_contact.errors.messages
      Rails.logger.error(@maintenance_contact.errors.messages)
    end
  end 

  private

  def get_maintenance_contact
    @maintenance_contact = ConnectMaintenanceContact.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @maintenance_contact.present?
  end

  def maintenance_contact_params
    params.require(:connect_maintenance_contact).permit(:location_id, :contact_type, :contact_order, :contact_first_name, :contact_last_name, :contact_phone_number, :contact_email,  :contact_admin, :contact_preference, :request_routing_url)
  end
  
  def search_maintenance_contact
    ConnectMaintenanceContact.order("#{field} #{order}").search_maintanence_contact_by_column_name(params[:search])
  end 
end
