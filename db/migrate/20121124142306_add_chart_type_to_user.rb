class AddChartTypeToUser < ActiveRecord::Migration
  def up
    add_column :users, :chart_type, :string, :default => "column"
  end
  def down
    remove_column :users, :chart_type
  end
end
