class AddEnumType < ActiveRecord::Migration
  def change
  	execute "drop type local_transport_type;" 
  	execute "create type local_transport_type as enum ('metro','bus');"
  	execute "alter table local_transport_stands drop COLUMN \"transportType\";"
  	execute "alter table local_transport_stands add \"localTransport\" local_transport_type;"

  	execute "drop type entry_point_type;" 
  	execute "create type entry_point_type as enum ('airport','railway');"
  	execute "alter table enrty_points drop COLUMN \"entryType\";"
  	execute "alter table enrty_points add \"entryType\" entry_point_type;"

  	# execute "drop type role_type;" 
  	# execute "create type role_type as enum ('reader','railway');"
  	# execute "alter table enrty_points drop COLUMN \"entryType\";"
  	# execute "alter table enrty_points add \"entryType\" entry_point_type;"
  end
end
