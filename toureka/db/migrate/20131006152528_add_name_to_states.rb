class AddNameToStates < ActiveRecord::Migration
  def change
    add_column :states, :name, :string
    add_index :states, :name
  end
end
