class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :likable, polymorphic: true
      t.references :user
      t.boolean :is_liked, null: false
      t.timestamps
    end
  end
end
