class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :name

      t.timestamps null: false
    end

    add_reference :tables, :user, index: true
  end
end
