class Feature::Guest::Upsert
	def initialize(info)
		@info = info
	end

	def call
		Guest.upsert(@info, unique_by: [:email])
	end
end
