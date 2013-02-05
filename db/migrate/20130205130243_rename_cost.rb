class RenameCost < ActiveRecord::Migration
  def up
    rename_column :records, :cost, :energy_cost
  end

  def down
    rename_column :records, :energy_cost, :cost
  end
end
