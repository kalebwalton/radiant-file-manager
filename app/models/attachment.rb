class Attachment < ActiveRecord::Base
  has_attachment :storage => :file_system, :thumbnails => { :thumb => '140>' },
                     :resize_to => "300>", :max_size => 25.megabytes
  validates_as_attachment
  validates_uniqueness_of :filename
end
