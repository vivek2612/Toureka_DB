class MakeStateNameNotNull < ActiveRecord::Migration
  def up
  	change_column :states, :name, :string, :null => false
  end

  def down
  end
end
