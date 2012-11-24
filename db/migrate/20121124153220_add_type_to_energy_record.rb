class AddTypeToEnergyRecord < ActiveRecord::Migration
  def up
    add_column :energy_records, :type, :string, null: false
  end
  def down
    remove_column :energy_records, :type
  end
end
