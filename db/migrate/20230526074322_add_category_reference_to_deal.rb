# frozen_string_literal: true

class AddCategoryReferenceToDeal < ActiveRecord::Migration[7.0]
  def change
    add_reference :deals, :category, foreign_key: true
  end
end
