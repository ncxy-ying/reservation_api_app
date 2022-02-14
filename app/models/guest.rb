class Guest < ApplicationRecord
	# include ActiveModel::Validations
	# attr_accessor :name, :email

	# validates :email, presence: true, uniqueness: true
	has_many :reservations

	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates :email, presence: true, uniqueness: true
end
