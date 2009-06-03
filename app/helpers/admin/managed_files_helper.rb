module Admin::ManagedFilesHelper
  def tab_link_to(label, name)
    if name == 'all'
      if request.request_uri =~ /.*selector.*/
        url = admin_managed_files_selector_by_type_url("all")
      else
        url = admin_managed_files_url
      end
    else
      if request.request_uri =~ /.*selector.*/
        url = admin_managed_files_selector_by_type_url(name)
      else
        url = admin_managed_files_by_type_url(name)
      end
    end
    link_to_unless_current(label, url, :class => "tab") do
      link_to(label, url, :class => "tab here")
    end
  end
end
