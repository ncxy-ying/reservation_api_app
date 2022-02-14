class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, :null => false
      t.string :phone_1
      t.string :phone_2

      t.index :email, unique: true

      t.timestamps
    end
  end
end
