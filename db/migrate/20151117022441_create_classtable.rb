class CreateClasstable < ActiveRecord::Migration
  def change
    create_table :classtables do |t|
      t.string :subject_code
      t.string :subject
      t.integer :daily
      t.integer :start
      t.integer :finish

      t.timestamps null: false
    end
    add_reference :classtables, :table, index: true
  end
end


