class RenameUsage < ActiveRecord::Migration
  def up
    rename_column :records, :usage, :amount
  end

  def down
    rename_column :records, :amount, :usage
  end
end
