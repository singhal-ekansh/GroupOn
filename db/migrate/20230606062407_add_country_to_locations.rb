# frozen_string_literal: true

class AddCountryToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :country, :string
  end
end
