class AddExamToClasstable < ActiveRecord::Migration
  def change
    add_column :classtables, :dayManual, :string
    add_column :classtables, :timeManual, :string
  end
end
