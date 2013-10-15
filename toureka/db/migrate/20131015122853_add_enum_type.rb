class AddEnumType < ActiveRecord::Migration
  def change
  	execute "drop type if exists local_transport_type;" 
  	execute "create type local_transport_type as enum ('metro','bus');"
  	execute "alter table local_transport_stands drop COLUMN \"transportType\";"
  	execute "alter table local_transport_stands add \"localTransport\" local_transport_type;"
  end
end
