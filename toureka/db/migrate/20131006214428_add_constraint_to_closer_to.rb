class AddConstraintToCloserTo < ActiveRecord::Migration
  def change
  	change_column :closer_tos, :distance, :integer, :null => false
  end
end
