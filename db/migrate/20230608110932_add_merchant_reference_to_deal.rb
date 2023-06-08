# frozen_string_literal: true

class AddMerchantReferenceToDeal < ActiveRecord::Migration[7.0]
  def change
    add_reference :deals, :merchant
  end
end
