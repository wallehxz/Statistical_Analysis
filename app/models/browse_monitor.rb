#encoding : utf-8
class BrowseMonitor < ActiveRecord::Base

  attr_accessible :load_time, :page_url, :visit_datetime, :upload, :visit_ip, :visit_city

end
