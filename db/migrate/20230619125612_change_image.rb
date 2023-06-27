# frozen_string_literal: true

class ChangeImage < ActiveRecord::Migration[7.0]
  def change;
    remove_column :images, :type
    remove_column :images, :deal_id
    add_reference :images, :imageable, polymorphic: true
  end
end
