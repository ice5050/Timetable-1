class AddColumnColorToClasstable < ActiveRecord::Migration
  def change
    add_column :classtables, :color, :string
  end
end
