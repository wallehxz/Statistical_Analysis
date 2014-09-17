class AddIndexToBrowseMonitors < ActiveRecord::Migration
  def change
      add_index :browse_monitors, :upload
      add_index :browse_monitors, :page_url
  end
end
