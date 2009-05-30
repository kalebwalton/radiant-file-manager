class Admin::ManagedFilesController < Admin::ResourceController

  def index
    conditions = case params[:file_type]
      when 'photos'     then 'content_type LIKE "image%" AND thumbnail IS NULL'
      when 'multimedia' then 'content_type LIKE "audio%" OR content_type LIKE "video%"'
      when 'internal'   then 'internal = true'
      when 'other'      then 'content_type NOT LIKE "image%" AND content_type NOT LIKE "audio%" AND content_type NOT LIKE "video%"'
      else                   'thumbnail IS NULL'
    end
    
    @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => conditions
  end

end
