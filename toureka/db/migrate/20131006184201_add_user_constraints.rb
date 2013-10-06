class AddUserConstraints < ActiveRecord::Migration
  def change
  	add_index :users, :username
  	change_column :users, :username, :string, :null => false
  	change_column :users, :password, :string, :null => false
  end
end
