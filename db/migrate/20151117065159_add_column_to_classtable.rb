class AddColumnToClasstable < ActiveRecord::Migration
  def change
    add_column :classtables, :room, :string
    add_column :classtables, :section, :string
  end
end
