class AddReferenceToClasstable < ActiveRecord::Migration
  def change
    add_reference :classtables, :user, index: true
  end
end
