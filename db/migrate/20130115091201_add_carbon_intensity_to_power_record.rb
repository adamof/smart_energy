class AddCarbonIntensityToPowerRecord < ActiveRecord::Migration
  def up
    add_column :records, :carbon_intensity, :float
    add_column :records, :carbon_result, :float
  end
  def down
    remove_column :records, :carbon_intensity
    remove_column :records, :carbon_result
  end
end
