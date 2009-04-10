namespace :rdb4o do
  desc "Compile java model files"
  task :compile_models do
    class_files = []
    Dir.glob("#{Merb.root}/app/models/java/*.java").each do |class_file|
      class_name = class_file.split('/')[-1].split('.')[0]
      puts "compiling #{class_name}..."
      #puts "  #{command}"
      class_files << class_file
    end
    command = "javac -cp #{Rdb4o::Base.base_classpath} #{class_files.join(' ')}"
    exec command
    puts "DONE"
  end

  namespace :db do
    desc "Clear session data from db"
    task :sessions_clear do
      Merb::MerbSesssions.delete_all
    end

    namespace :server do

      desc "Clear session data from db"
      task :start do
        f = File.new('log/db4o_server.pid','w') 
        f.write Process.pid
        f.close
        puts "Starting db4o server... "
        #fork { 
          Merb::Orms::Rdb4o.start_server 
          puts "Server started ok. Pidfile is log/db4o_server.pid"
          sleep        
          #puts "never see this"
        #}
      end

      desc "Clear session data from db"
      task :stop do
        Merb::MerbSesssions.delete_all
      end    
    end
  end
end