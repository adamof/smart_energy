class CreateEnergyRecordModel < ActiveRecord::Migration
  def up
    create_table :energy_records do |t|
      t.integer   :household_id
      t.float     :usage
      t.datetime  :period_end
      t.timestamps
    end
  end

  def down
    drop_table :energy_records
  end
end
