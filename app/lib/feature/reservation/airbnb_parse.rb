class Feature::Reservation::AirbnbParse
	def initialize(payload)
		@payload = payload
	end

	def call
		first_name, last_name, email, phone_1 = nil
		guest = @payload[:guest]

		if guest.present?
			first_name = guest[:first_name]
			last_name = guest[:last_name]
			email = guest[:email]
			phone_1 = guest[:phone]
		end

		{
			'guest': {
				'first_name': first_name,
				'last_name':  last_name,
				'email': 	  email,
				'phone_1': 	  phone_1
			},
			'reservation': {
				'code': 		  @payload[:reservation_code],
				'start_date': 	  @payload[:start_date],
				'end_date': 	  @payload[:end_date],
				'total_nights':   @payload[:nights],
				'total_guests':   @payload[:guests],
				'reserve_status': @payload[:status],
				'currency': 	  @payload[:currency],
				'payout_price':   @payload[:payout_price],
				'security_price': @payload[:security_price],
				'total_price': 	  @payload[:total_price],
				'total_adults':   @payload[:adults],
				'total_children': @payload[:children],
				'total_infants':  @payload[:infants]
			}
		}
	end
end