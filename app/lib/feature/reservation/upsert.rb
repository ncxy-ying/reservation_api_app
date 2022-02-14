class Feature::Reservation::Upsert
	def initialize(guest_email, info)
		@guest_email = guest_email
		@info = info
	end

	def call
		guest = Guest.find_by(email: @guest_email)
		if guest.present?
			@info[:guest_id] = guest.id
			Reservation.upsert(@info, unique_by: [:code])
		else
			raise 'Guest not found'
		end
	end
end
