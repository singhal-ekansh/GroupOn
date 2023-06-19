# frozen_string_literal: true

class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :code, null: false, index: { unique: true }
      t.references :order
      t.datetime :redeemed_at
      t.timestamps
    end
  end
end
