# frozen_string_literal: true

class AddStripeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_customer_id, :string
  end
end
