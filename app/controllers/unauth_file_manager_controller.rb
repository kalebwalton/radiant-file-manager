class UnauthFileManagerController < ApplicationController
  no_login_required
  
  def get
    attachment = Attachment.find_by_filename(params[:fn])
    send_data attachment.db_file.data, :filename => attachment.filename,
                                       :type => attachment.content_type,
                                       :disposition => 'inline'
  end

  def list_js
    # Lists the attachments for the Rich Text Editor to use
    @attachments = Attachment.find(:all, :conditions => 'content_type LIKE "%image%" AND thumbnail IS NULL')
    @attachments.collect! {|x| x.filename =~ /(gif|png|jpg|jpeg)/ ? x : nil}.compact!
    render :action => "list_js", :layout => false
  end

end
