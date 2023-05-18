class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.string :pincode, null: false
      t.timestamps
    end

    create_table :deals_locations, id: false do |t|
      t.belongs_to :deal
      t.belongs_to :location
    end
  end
end
