class CreateRegularexams < ActiveRecord::Migration
  def change
    create_table :regularexams do |t|
      t.integer :dayexam
      t.integer :timeexam
      t.string :dateexam

      t.timestamps null: false
    end
  end
end
