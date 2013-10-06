class CreateInProximityOfs < ActiveRecord::Migration
  def change
    create_table :in_proximity_ofs do |t|
      t.integer :distance

      t.timestamps
    end
  end
end
