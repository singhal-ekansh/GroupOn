class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :deal
      t.references :user
      t.boolean :liked
      t.timestamps
    end
  end
end
