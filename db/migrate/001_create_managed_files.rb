class CreateManagedFiles < ActiveRecord::Migration
  class << self
    def up
      create_table :managed_files, :force => true do |t|
        t.column "content_type", :string
        t.column "filename", :string     
        t.column "size", :integer
        t.column "db_file_id", :integer # only for db files (optional)
    
        # only for thumbnails
        t.column "parent_id",  :integer 
        t.column "thumbnail", :string
    
        # only for images (optional)
        t.column "width", :integer  
        t.column "height", :integer

        t.column "created_at", :datetime
        t.column "updated_at", :datetime

      end
    
      create_table :db_files, :force => true do |t|
        t.column :data, :binary
      end
    end

    def down
      drop_table :managed_files
      drop_table :db_files
    end

  end
end
