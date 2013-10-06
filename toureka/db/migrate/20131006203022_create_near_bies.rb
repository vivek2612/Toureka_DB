class CreateNearBies < ActiveRecord::Migration
  def change
    create_table :near_bies do |t|
      t.integer :distance

      t.timestamps
    end
  end
end
