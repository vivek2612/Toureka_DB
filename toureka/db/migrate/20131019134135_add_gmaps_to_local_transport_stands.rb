class AddGmapsToLocalTransportStands < ActiveRecord::Migration
  def change
    add_column :local_transport_stands, :gmaps, :boolean
  end
end
