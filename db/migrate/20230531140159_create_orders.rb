# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.integer :amount
      t.datetime :processed_at
      t.integer :status, default: 0
      t.references :deal
      t.references :user
      t.timestamps
    end
  end
end
