require_dependency 'application'
#require File.join(File.dirname(__FILE__), 'vendor/plugins/attachment_fu/lib/technoweenie/attachment_fu')
#require File.join(File.dirname(__FILE__), 'vendor/will_paginate/lib/will_paginate')
#require File.join(File.dirname(__FILE__), 'vendor/will_paginate/lib/will_paginate/view_helpers')

class FileManagerExtension < Radiant::Extension
  version "1.0"
  description "File Manager Extension"
  url "http://yourwebsite.com/file_manager"
  
  define_routes do |map|
    map.connect 'admin/file_manager/:action', :controller => 'file_manager'
    map.connect 'file/:action', :controller => 'unauth_file_manager'
  end
  
  def activate
    admin.tabs.add "Files", "/admin/file_manager", :after => "Layouts", :visibility => [:all]
    unless Radiant::Config["file_manager.max_files_per_upload"]
      Radiant::Config.create(:key => "file_manager.max_files_per_upload", :value => 3)
    end
  end
  
  def deactivate
    admin.tabs.remove "Files"
  end
  
end
