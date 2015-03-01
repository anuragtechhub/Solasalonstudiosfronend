class StylistsController < ApplicationController
  before_action :set_stylist, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @stylists = Stylist.all
    respond_with(@stylists)
  end

  def show
    respond_with(@stylist)
  end

  def new
    @stylist = Stylist.new
    respond_with(@stylist)
  end

  def edit
  end

  def create
    @stylist = Stylist.new(stylist_params)
    @stylist.save
    respond_with(@stylist)
  end

  def update
    @stylist.update(stylist_params)
    respond_with(@stylist)
  end

  def destroy
    @stylist.destroy
    respond_with(@stylist)
  end

  private
    def set_stylist
      @stylist = Stylist.find(params[:id])
    end

    def stylist_params
      params.require(:stylist).permit(:name, :url_name, :biography, :email_address, :phone_number, :studio_number, :work_hours, :website, :business_name, :hair, :skin, :nails, :massage, :teeth_whitening, :hair_extensions, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients, :booking_url)
    end
end
