class BookingsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_booking, only: [:show, :update, :destroy]

rescue_from ActiveRecord::RecordInvalid, with: :valid_booking

rescue_from CanCan::AccessDenied do |exception|
    render json: {warning: exception, status: "authorization_failed"}
end

    def index
        @bookings = Booking.all
        # @bookings = current_user.bookings
        render json: @bookings, status: :ok
    end

    def show
        render json: @booking, status: :ok
    end

    def create
        @booking = current_user.bookings.create!(booking_params)
        render json: @booking, status: :created
    end

    def update
        @booking.update!(booking_params)
        render json: @booking, status: :ok
    end

    def destroy
        if @booking.destroy
          render json: {}
        else
            render json: {error: "Something went wrong"}
        end 
    end

    private 

    def set_booking
        @booking = current_user.bookings.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: :unauthorized
    end

    def booking_params
        params.permit(:no_of_tickets, :amount_paid, :user_id, :event_id)
    end

    def valid_booking(valid)
        render json:{errors: valid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
