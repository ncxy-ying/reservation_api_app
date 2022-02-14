class Feature::Reservation::BookcomParse
	def initialize(payload)
		@payload = payload
	end

	def call
		phone_1, phone_2 = nil
		total_adults, total_children, total_infants = nil
		reservation = @payload[:reservation]
		return { 'guest': {}, 'reservation': {} } unless reservation.present?

		guest_details = reservation[:guest_details]

		if reservation[:guest_phone_numbers].present?
			phone_1 = reservation[:guest_phone_numbers][0]
			phone_2 = reservation[:guest_phone_numbers][1]
		end

		if guest_details.present?
			total_adults = guest_details[:number_of_adults]
			total_children = guest_details[:number_of_children]
			total_infants = guest_details[:number_of_infants]
		end
		{
			'guest': {
				'first_name': reservation[:guest_first_name],
				'last_name':  reservation[:guest_last_name],
				'email': 	  reservation[:guest_email],
				'phone_1':    phone_1,
				'phone_2': 	  phone_2
			},
			'reservation': {
				'code': 		  reservation[:code],
				'start_date':     reservation[:start_date],
				'end_date': 	  reservation[:end_date],
				'total_nights':   reservation[:nights],
				'total_guests':   reservation[:number_of_guests],
				'reserve_status': reservation[:status_type],
				'currency': 	  reservation[:host_currency],
				'payout_price':   reservation[:expected_payout_amount],
				'security_price': reservation[:listing_security_price_accurate],
				'total_price': 	  reservation[:total_paid_amount_accurate],
				'total_adults':   total_adults,
				'total_children': total_children,
				'total_infants':  total_infants
			}
		}
	end
end