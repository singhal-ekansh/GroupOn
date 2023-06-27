# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :reviewable, polymorphic: true
      t.text :body
      t.references :user
      t.timestamps
    end
  end
end
