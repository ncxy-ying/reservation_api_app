class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, presence: true, uniqueness: true
  enum reserve_status: [:accepted, :rejected]
end
