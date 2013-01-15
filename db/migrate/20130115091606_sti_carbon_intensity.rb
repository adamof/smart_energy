class StiCarbonIntensity < ActiveRecord::Migration
  def up
    add_column :carbon_intensities, :type, :string
  end

  def down
    remove_column :carbon_intensities, :type
  end
end
