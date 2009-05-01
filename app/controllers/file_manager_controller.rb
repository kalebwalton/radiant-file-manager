class FileManagerController < ApplicationController
  before_filter :set_num_files

  def set_num_files
    @num_files = Radiant::Config["file_manager.max_files_per_upload"].to_i
  end
  
  def index
    list
  end

  def list

    # May need to revert to the following
    # @attachment_pages, @attachments = paginate :attachments, :order => 'filename', :conditions => 'thumbnail IS NULL', :per_page => 20
    if params[:file_type] == 'document'
      @attachments = Attachment.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type NOT LIKE "%image%"'
    else
      @attachments = Attachment.paginate :page => params[:page], :order => 'filename', :conditions => 'content_type LIKE "%image%" AND thumbnail IS NULL'
    end
  
    render :action => "list"
  end

  def new
    @num_files.times do |num|
      eval("@attachment#{num} = Attachment.new")
    end
  end

  def show
    if params[:id]
      @attachment = Attachment.find params[:id]
    elsif params[:ids]
      @attachments = Attachment.find(:all,  params[:ids])
    end
  end

  def create
    @uploaded_attachments = []

    @num_files.times do |i|
      attachment = handle_attachment(i+1)
      if !attachment.nil?
        @uploaded_attachments.push(attachment)
      end
    end

    errors = false
    @uploaded_attachments.each do |attachment|
      if !attachment.errors.empty?
        errors = true
        break
      end
    end

    list
  end

  def handle_attachment(num)
    attachment = Attachment.new params['attachment'+num.to_s]
    #@todo need much better error handling here
    return if !attachment.valid?

    attachment.save
    attachment
  end

  def destroy
    attachment = Attachment.find(params[:id])
    attachment.destroy()
    flash[:notice] = "'#{attachment.filename}' deleted"
    redirect_to :action => 'list', :page => params[:page], :file_type => params[:file_type]
  end

end
