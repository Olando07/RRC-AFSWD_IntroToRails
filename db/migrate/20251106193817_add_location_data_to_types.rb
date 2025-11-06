class AddLocationDataToTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :types, :latitude, :decimal
    add_column :types, :longitude, :decimal
    add_column :types, :location_name, :string
  end
end
