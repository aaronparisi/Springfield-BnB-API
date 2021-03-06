class Api::BookingsController < ApplicationController
  before_action :find_booking, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

  def index
    current_uri = request.env['PATH_INFO']

    if current_uri.include?('properties')
      # we are getting bookings for a property
      @bookings = Booking.where(property_id: params[:id]).includes(:property, :guest)
    else
      # we are getting bookings for a guest
      @bookings = Booking.where(guest_id: params[:id]).includes(:property, :guest)
    end
    # ? include other info?
    render :index
  end

  def managedIndex
    @bookings = Booking.where(manager_id: params[:id]).includes(:property, :guest)
  end

  def show
    
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.start_date = @booking.start_date.to_datetime.change({ hour: 16 })
    @booking.end_date = @booking.end_date.to_datetime.change({ hour: 16 })
    
    if @booking.save
      render :show
    else
      render json: @booking.errors.full_messages, status: 401
    end
  end

  def upate
    if @booking.update_attributes(booking_params)
      render :show
    else
      render json: @booking.errors.full_messages, status: 401
    end
  end

  def destroy
    if @booking.destroy
      render :show
    else
      render ['Error destroying booking']
    end
  end

  private

  def find_booking
     @booking = Booking.includes(:property, :guest).find(params[:id])
  end
  
  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :guest_id, :property_id)
  end
end
