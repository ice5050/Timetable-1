class AddColumnToRegular < ActiveRecord::Migration
  def change
    add_column :regularexams, :yearexam, :integer
    add_column :regularexams, :semesterexam, :integer
  end
end
