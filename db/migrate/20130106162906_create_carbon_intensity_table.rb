class CreateCarbonIntensityTable < ActiveRecord::Migration
  def up
    create_table :carbon_intensities do |t|
      t.datetime :period
      t.float :value
    end
  end

  def down
    drop_table :carbon_intensities
  end
end
