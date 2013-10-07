class AddDistrictConstraints < ActiveRecord::Migration
	def change
		change_column :districts, :name, :string, :null => false
		add_index :districts, [:state_id, :name]
	end
end
