class FileBrowserController < ApplicationController
  session :off
  skip_before_filter :verify_authenticity_token

  no_login_required

  def index
    case params[:type]
      when "image"
        @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type LIKE "%image%" AND thumbnail IS NULL', :per_page => 100
      when "file"
        @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type NOT LIKE "%image%"', :per_page => 100
      else
        @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => 'thumbnail IS NULL', :per_page => 100
    end

    include_javascript "file_browser"
    render :layout => "file_browser"
  end
  
end
