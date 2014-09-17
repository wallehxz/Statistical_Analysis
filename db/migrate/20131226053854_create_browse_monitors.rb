class CreateBrowseMonitors < ActiveRecord::Migration
  def change
    create_table :browse_monitors do |t|
      t.text        :page_url
      t.string      :load_time
      t.date        :upload
      t.datetime :visit_datetime

      t.timestamps
    end
  end
end
