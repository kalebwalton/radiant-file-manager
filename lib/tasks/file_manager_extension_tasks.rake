namespace :radiant do
  namespace :extensions do
    namespace :file_manager do
      
      desc "Runs the migration of the File Manager extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FileManagerExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FileManagerExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the File Manager to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from FileManagerExtension"
        Dir[FileManagerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FileManagerExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
