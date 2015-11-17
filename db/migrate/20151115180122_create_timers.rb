class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.string :time

      t.timestamps null: false
    end
  end
end
