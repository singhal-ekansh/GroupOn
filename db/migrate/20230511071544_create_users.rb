class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false
      t.string :password_digest
      t.boolean :is_admin, default: false
      t.timestamp :verified_at
      t.timestamp :password_last_reset_at
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
