# frozen_string_literal: true
class Api::SolaCms::BookNowBookingsController < Api::SolaCms::ApiController
  before_action :set_booking, only: %i[ show update destroy]

  #GET /book_now_booking
  def index
    if params[:search].present?
      bookings = BookNowBooking.search_booking(params[:search])
      bookings = paginate(bookings)
      render json:  { bookings: bookings }.merge(meta: pagination_details(bookings))
    else  
      bookings = BookNowBooking.all
      bookings = paginate(bookings)
      render json: { bookings: bookings }.merge(meta: pagination_details(bookings))
    end
  end

  #POST /book_now_booking
  def create
    @booking  =  BookNowBooking.new(booking_params)
    if @booking.save
      render json: @booking 
    else
      Rails.logger.info(@booking.errors.messages)
      render json: {error: @booking.errors.messages}, status: 400  
    end
  end

  #GET /book_now_booking/:id
  def show
    render json: @booking
  end

  #PUT /book_now_booking/:id
  def update
    if @booking.update(booking_params)
      render json: {message: "Booking Successfully Updated." }, status: 200
    else
      Rails.logger.info(@booking.errors.messages)
      render json: {error: @booking.errors.messages}, status: 400 
    end
  end

  #DELETE /book_now_booking/:id
  def destroy
    if @booking&.destroy
      render json: {message: "Booking Successfully Deleted."}, status: 200
    else
      @booking.errors.messages
      Rails.logger.info(@booking.errors.messages)
    end
  end

  private

  def set_booking
    @booking = BookNowBooking.find_by(id: params[:id])
    render json: { message: 'Record not found' }, status: 400 unless @booking.present?
  end

  def booking_params
    params.require(:booking).permit(:time_range, :location_id, :query, :stylist_id, :booking_user_name, :booking_user_phone, :booking_user_email, :referring_url, :total, services: [:description, :duration, :guid, :image, :name, :price])
  end
end