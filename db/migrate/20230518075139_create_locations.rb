class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :address
      t.string :state
      t.string :city
      t.string :pincode
      t.references :deal, foreign_key: true
      t.timestamps
    end
  end
end
