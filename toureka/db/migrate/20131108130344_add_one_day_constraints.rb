class AddOneDayConstraints < ActiveRecord::Migration
	def change
		change_column :one_days, :start_date, :date, :null => false
		change_column :one_days, :day_number, :integer, :null => false
	end
end
