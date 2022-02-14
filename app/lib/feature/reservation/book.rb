class Feature::Reservation::Book
	def initialize(params)
		@params = params
	end

	def call
		if airbnb?
			info = Feature::Reservation::AirbnbParse.new(@params).call
		elsif bookcom?
			info = Feature::Reservation::BookcomParse.new(@params).call
		else
			# raise Errors::PayloadNotMatch.new 
			raise "Payload not match"
		end

		if info[:guest].present? && info[:guest][:email].present?
			Feature::Guest::Upsert.new(info[:guest]).call
			guest = Guest.find_by(email: info[:guest][:email])
			if guest.present?
				Feature::Reservation::Upsert.new(info[:guest][:email], info[:reservation]).call
				true
			else
				false
			end
		else
			false
		end
	end

	private

	# assume payload 1 from airbnb
	def airbnb?
		@params.key?(:reservation_code)
	end

	# assume payload 2 from booking.com
	def bookcom?
		@params.key?(:reservation)
	end
end
