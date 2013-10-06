class RemoveNameFromStates < ActiveRecord::Migration
  def up
    remove_column :states, :name
  end

  def down
    add_column :states, :name, :string
  end
end
