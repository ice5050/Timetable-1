class RenameOrderToOrderedFromRegularexam < ActiveRecord::Migration
  def change
    rename_column :regularexams, :order, :ordered
  end
end
