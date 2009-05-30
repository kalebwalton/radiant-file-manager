module Admin::ManagedFilesHelper
  def tab_link_to(label, url)
    link_to_unless_current(label, url, :class => "tab") do
       link_to(label, url, :class => "tab here")
    end
  end
end
