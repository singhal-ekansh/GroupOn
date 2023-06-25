# frozen_string_literal: true

class CreateReferral < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals do |t|
      t.references :user
      t.string :referee_email
      t.references :deal
      t.datetime :invitation_accepted_at
      t.datetime :redeemed_at
      t.timestamps :timestamps
    end
  end
end
