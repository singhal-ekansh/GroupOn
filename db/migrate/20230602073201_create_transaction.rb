# frozen_string_literal: true

class CreateTransaction < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|

      t.string :stripe_id
      t.references :order
      t.integer :status
      t.timestamps
    end
  end
end
