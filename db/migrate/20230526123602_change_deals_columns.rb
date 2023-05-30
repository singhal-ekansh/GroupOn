class ChangeDealsColumns < ActiveRecord::Migration[7.0]
  def change 
    change_table :deals do |t|
      t.change :description, :text, null: true
      t.change :price, :integer, null: true
      t.change :start_at, :datetime, null: true
      t.change :expire_at, :datetime, null: true
      t.change :threshold_value, :integer, null: true
      t.change :total_availaible, :integer, null: true
      t.rename :count_left, :qty_sold
      t.change :qty_sold, :integer, default: 0
    end
  end
end
