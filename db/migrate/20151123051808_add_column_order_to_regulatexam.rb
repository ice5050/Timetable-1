class AddColumnOrderToRegulatexam < ActiveRecord::Migration
  def change
    add_column :regularexams, :order, :integer
  end
end
