class AddColumnYearToTables < ActiveRecord::Migration
  def change
    add_column :tables, :year, :integer
    add_column :tables, :semester, :integer
  end
end
