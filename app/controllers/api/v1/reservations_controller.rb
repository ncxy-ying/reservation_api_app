class Api::V1::ReservationsController < ApplicationController
	def book
		if Feature::Reservation::Book.new(reservation_params).call
			render json: {
							status: 'SUCCESS',
							message: 'Booking success',
							data: nil 
						}, status: :ok
		else
			render json: {
							status: 'Error',
							message: 'Failed to book',
							data: nil
						}, status: :unprocessable_entity
		end
	end

	private

    def reservation_params
      	params.permit(
      		# payload 1
      		:reservation_code, :start_date, :end_date, :nights, :guests, :adults,
      		:children, :infants, :status, :currency, :payout_price, :security_price,
			:total_price,
      		guest: [
      			:first_name, :last_name, :phone, :email
      		],

      		# payload 2
      		reservation: [
      			:code, :start_date, :end_date, :expected_payout_amount, :guest_email,
      			:guest_first_name, :guest_last_name,  :listing_security_price_accurate,
      			:host_currency, :nights, :number_of_guests, :status_type,
      			:total_paid_amount_accurate, guest_phone_numbers: [],
      			guest_details: [
      				:localized_description, :number_of_adults, :number_of_children,
      				:number_of_infants,
      			]
      		],
      	)
    end
end
