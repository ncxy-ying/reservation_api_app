class AddFieldToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :total_adults, :integer
    add_column :reservations, :total_children, :integer
    add_column :reservations, :total_infants, :integer
  end
end
