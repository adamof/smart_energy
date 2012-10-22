class CreateHouseholdModel < ActiveRecord::Migration
  def up
    create_table :households do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :households
  end
end
