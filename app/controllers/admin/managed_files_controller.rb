class Admin::ManagedFilesController < Admin::ResourceController

  before_filter :set_num_files

  def set_num_files
    @num_files = Radiant::Config["file_manager.max_files_per_upload"].to_i
  end
  
  def index
    list
  end

  def list_js
    # Lists the managed_files for the Rich Text Editor to use
    @managed_files = ManagedFile.find(:all, :conditions => 'content_type LIKE "%image%" AND thumbnail IS NULL')
    @managed_files.collect! {|x| x.filename =~ /(gif|png|jpg|jpeg)/ ? x : nil}.compact!
    render :action => "list_js", :layout => false
  end

  def list

    # May need to revert to the following
    # @managed_file_pages, @managed_files = paginate :managed_files, :order => 'filename', :conditions => 'thumbnail IS NULL', :per_page => 20
    if params[:file_type] == 'document'
      @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type NOT LIKE "%image%"'
    else
      @managed_files = ManagedFile.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type LIKE "%image%" AND thumbnail IS NULL'
    end
  
    render :action => "list"
  end

  def new
    @num_files.times do |num|
      eval("@managed_file#{num} = ManagedFile.new")
    end
  end

  def show
    if params[:id]
      @managed_file = ManagedFile.find params[:id]
    elsif params[:ids]
      @managed_files = ManagedFile.find(:all,  params[:ids])
    end
  end

  def create
    @uploaded_managed_files = []

    @num_files.times do |i|
      managed_file = handle_managed_file(i+1)
      if !managed_file.nil?
        @uploaded_managed_files.push(managed_file)
      end
    end

    errors = false
    @uploaded_managed_files.each do |managed_file|
      if !managed_file.errors.empty?
        errors = true
        break
      end
    end

    list
  end

  def handle_managed_file(num)
    managed_file = ManagedFile.new params['managed_file'+num.to_s]
    #@todo need much better error handling here
    return if !managed_file.valid?

    managed_file.save
    managed_file
  end

  def destroy
    managed_file = ManagedFile.find(params[:id])
    managed_file.destroy()
    flash[:notice] = "'#{managed_file.filename}' deleted"
    redirect_to :action => 'list', :page => params[:page], :file_type => params[:file_type]
  end

end
