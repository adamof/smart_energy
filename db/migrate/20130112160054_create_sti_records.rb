class CreateStiRecords < ActiveRecord::Migration
  def up
    rename_table :energy_records, :records
  end

  def down
    rename_table :records, :energy_records
  end
end
