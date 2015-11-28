class RenameColumnAndAddColumnToClasstable < ActiveRecord::Migration
  def change
    rename_column :classtables, :dayManual, :dayFinal
    rename_column :classtables, :timeManual, :timeFinal
    add_column :classtables, :dayMidterm, :string
    add_column :classtables, :timeMidterm, :string
  end
end
