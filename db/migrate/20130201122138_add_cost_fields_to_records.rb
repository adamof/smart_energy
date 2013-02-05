class AddCostFieldsToRecords < ActiveRecord::Migration
  def up
    add_column :records, :price, :float
    add_column :records, :cost, :float
  end
  def down
    remove_column :records, :price
    remove_column :records, :cost
  end
end
