class Admin::ManagedFilesController < Admin::ResourceController

  def index
    conditions = case params[:file_type]
      when 'photos'     then 'content_type LIKE "image%" AND thumbnail IS NULL'
      when 'flash'      then 'content_type LIKE "application/x-shockwave-flash"'
      when 'multimedia' then 'content_type LIKE "audio%" OR content_type LIKE "video%"'
      when 'internal'   then 'internal = true'
      when 'other'      then 'content_type NOT LIKE "image%" AND content_type NOT LIKE "audio%" AND content_type NOT LIKE "video%" AND content_type NOT LIKE "application/x-shockwave-flash"'
      else                   'thumbnail IS NULL'
    end
    
    @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => conditions

    # Support for fckeditor file selector
    if request.request_uri =~ /.*selector.*/
      include_javascript "file_browser"
      render :layout => "file_browser"
    end
  end

end
