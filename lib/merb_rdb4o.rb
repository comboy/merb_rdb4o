# make sure we're running inside Merb
if defined?(Merb::Plugins)

  require File.dirname(__FILE__) / "merb" / "orms" / "rdb4o" / "connection"
  require File.dirname(__FILE__) / "merb" / "orms" / "rdb4o" / "model"
  require File.dirname(__FILE__) / "merb" / "session" / "rdb4o_session"
  
  require 'rdb4o'    
  $CLASSPATH << "#{File.dirname(__FILE__)}/java"
  
  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:merb_db4o] = {
    :autoload_models => true
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application

    if Merb::Plugins.config[:merb_db4o][:autoload_models]
      $CLASSPATH << Merb.root
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
    
    unless Regexp.new(Regexp.escape('rdb4o:db:server')).match ARGV[0]
      Merb::Orms::Rdb4o.connect
      Merb::Orms::Rdb4o.register_session_type
    end
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "merb_rdb4o/merbtasks"
end