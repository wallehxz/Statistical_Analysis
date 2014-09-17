class AddIpCityToBrowseMonitors < ActiveRecord::Migration
  def change
    add_column :browse_monitors, :visit_ip, :string
    add_column :browse_monitors, :visit_city, :string
  end
end
