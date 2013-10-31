class StateTrial < ActiveRecord::Migration
  def up
  	State.create( :name => "MP")
  end

  def down
  end
end
