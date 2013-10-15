class EntryPointEnum < ActiveRecord::Migration
  def change
  	execute "drop type if exists entry_point_type;" 
  	execute "create type entry_point_type as enum ('airport','railway');"
  	execute "alter table entry_points drop COLUMN \"entryType\";"
  	execute "alter table entry_points add \"entryType\" entry_point_type;"
  end
end
