class AddNearByConstraints < ActiveRecord::Migration
  def change
  	change_column :near_bies, :distance, :integer, :null => false
  end
end
