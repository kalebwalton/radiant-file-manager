class Admin::ManagedFilesController < Admin::ResourceController

  def create
    uploaded_data = params[:managed_file][:uploaded_data] unless params[:managed_file].nil?
    # Make sure we have a content-type if it came in as nil
    uploaded_data.content_type = "text/plain" if !uploaded_data.nil? && uploaded_data.content_type.nil?
    model.update_attributes!(params[model_symbol])
    announce_saved
    response_for :create
  end

  def index
    conditions = case params[:file_type]
      when 'photos'     then 'content_type LIKE "image%" AND thumbnail IS NULL'
      when 'flash'      then 'content_type LIKE "application/x-shockwave-flash"'
      when 'multimedia' then 'content_type LIKE "audio%" OR content_type LIKE "video%"'
      when 'internal'   then 'internal = true'
      when 'other'      then 'content_type NOT LIKE "image%" AND content_type NOT LIKE "audio%" AND content_type NOT LIKE "video%" AND content_type NOT LIKE "application/x-shockwave-flash"'
      else                   'thumbnail IS NULL'
    end

    unless current_user.admin? || current_user.developer? || (current_user.respond_to?(:site_admin?) ? current_user.site_admin? : false)
      conditions += ' AND internal = 0'
    end

    @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => conditions

    # Support for fckeditor file selector
    if request.request_uri =~ /.*selector.*/
      include_javascript "file_browser"
      render :layout => "file_browser"
    end
  end

end
