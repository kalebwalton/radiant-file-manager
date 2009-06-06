class ManagedFile < ActiveRecord::Base
  has_attachment :storage => :file_system, :thumbnails => { :thumb => '75>' }, :max_size => 25.megabytes
  validates_as_attachment
  validates_uniqueness_of :filename, :message => "is already in use"

  # Fixes the image file size after being resized
  after_resize do |record, img|
    record.size = File.size(record.temp_path)
  end
end
