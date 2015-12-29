class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
        t.string :stuId
        t.string :urlImg
        t.timestamps null: false
    end
  end
end
