class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :guest, null: false, foreign_key: true
      t.string :code, :null => false
      t.date :start_date
      t.date :end_date
      t.integer :total_nights
      t.integer :total_guests
      t.integer :reserve_status
      t.string :currency
      t.decimal :payout_price, :precision => 8, :scale => 2
      t.decimal :security_price, :precision => 8, :scale => 2
      t.decimal :total_price, :precision => 8, :scale => 2

      t.index :code, unique: true

      t.timestamps
    end
  end
end
