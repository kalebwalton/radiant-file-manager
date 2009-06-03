require_dependency 'application'
#require File.join(File.dirname(__FILE__), 'vendor/plugins/attachment_fu/lib/technoweenie/attachment_fu')
#require File.join(File.dirname(__FILE__), 'vendor/will_paginate/lib/will_paginate')
#require File.join(File.dirname(__FILE__), 'vendor/will_paginate/lib/will_paginate/view_helpers')

class FileManagerExtension < Radiant::Extension
  version "1.0"
  description "File Manager Extension"
  url "http://yourwebsite.com/file_manager"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :managed_files, :member => { :remove => :get }
      admin.named_route :managed_files_by_type, 'managed_files/type/:file_type', :controller => 'managed_files', :action => 'index'
      admin.resources :managed_files_selector, :member => { :remove => :get }
      admin.named_route :managed_files_selector_by_type, 'managed_files_selector/type/:file_type', :controller => 'managed_files', :action => 'index'
    end
  end
  
  def activate
    admin.tabs.add "Files", "/admin/managed_files", :after => "Layouts", :visibility => [:all]
    if Radiant::Config.table_exists?
      unless Radiant::Config["file_manager.max_files_per_upload"]
        Radiant::Config.create(:key => "file_manager.max_files_per_upload", :value => 3)
      end
    end
  end
  
  def deactivate
    admin.tabs.remove "Files"
  end
  
end
