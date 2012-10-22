class AddHouseholdAssociationToUser < ActiveRecord::Migration
  def change
    add_column :users, :household_id, :integer
  end
end
