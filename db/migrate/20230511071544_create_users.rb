class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest
      t.boolean :is_admin, default: false
      t.datetime :verified_at
      t.datetime :password_last_reset_at
      t.timestamps
    end
  end
end
