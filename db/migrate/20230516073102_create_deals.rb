class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.datetime :start_at, null: false
      t.datetime :expire_at, null: false
      t.integer :threshold_value, null: false
      t.integer :total_availaible, null: false
      t.integer :max_per_user
      t.boolean :published, default: false
      t.integer :count_left
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
