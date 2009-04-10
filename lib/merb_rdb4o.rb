# make sure we're running inside Merb
if defined?(Merb::Plugins)
  
  $CLASSPATH << "#{File.dirname(__FILE__)}/java"
  
  require File.dirname(__FILE__) / "merb" / "orms" / "rdb4o" / "connection"
  require File.dirname(__FILE__) / "merb" / "orms" / "rdb4o" / "model"
  require File.dirname(__FILE__) / "merb" / "session" / "rdb4o_session"
  Merb::Plugins.add_rakefiles "merb_rdb4o/merbtasks"
  
  require 'rdb4o'    
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_db4o] = {
    :autoload_models => true
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application

    if Merb::Plugins.config[:merb_db4o][:autoload_models]
      $CLASSPATH << Merb.root
      $CLASSPATH << Rdb4o::Model.base_classpath
      Dir.glob("#{Merb.root}/app/models/java/*.java").each do |class_file|
        if File.exists? "#{class_file.split('.')[0]}.class"
          class_name = class_file.split('/')[-1].split('.')[0]
          # FIXME: EVAL = EVIL !!!
          # should be some const_get
          model_class = eval("Java::app::models::java::#{class_name}")
          Object.const_set class_name, model_class
          Rdb4o.set_model model_class 
        end
      end      
    end
    
    # unless Regexp.new(Regexp.escape('rdb4o:db:server')).match ARGV[0]
    #   Merb::Orms::Rdb4o.connect
    #   Merb::Orms::Rdb4o.register_session_type
    # end
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
<<<<<<< HEAD:lib/merb_rdb4o.rb
  Merb::Plugins.add_rakefiles "merb_rdb4o/merbtasks"
=======
  
  generators = File.join(File.dirname(__FILE__), 'generators')
  Merb.add_generators generators / 'rdb4o_model'
>>>>>>> teamon_merb:lib/merb_rdb4o.rb
end
