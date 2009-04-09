require 'fileutils'
require 'rdb4o'

module Merb
  module Orms
    module Rdb4o
      class << self
        def config_file() Merb.root / "config" / "database.yml" end
        def sample_dest() Merb.root / "config" / "database.yml.sample" end
        def sample_source() File.dirname(__FILE__) / "database.yml.sample" end
      
        def copy_sample_config
          FileUtils.cp sample_source, sample_dest unless File.exists?(sample_dest)
        end
      
        def config
          @config ||=
            begin
              # Convert string keys to symbols
              full_config = Erubis.load_yaml_file(config_file)
              config = (Merb::Plugins.config[:merb_db4o] = {})
              (full_config[Merb.environment.to_sym] || full_config[Merb.environment]).each do |k, v| 
                if k == 'port'
                  config[k.to_sym] = v.to_i
                else
                  config[k.to_sym] = v
                end
              end
              config
            end
        end
      
        # Database connects as soon as the gem is loaded
        def connect
          if File.exists?(config_file)
            Merb.logger.info!("Connecting to database...")
            ::Rdb4o::Database.setup(config)
          else
            copy_sample_config
            Merb.logger.error! "No database.yml file found in #{Merb.root}/config."
            Merb.logger.error! "A sample file was created called database.sample.yml for you to copy and edit."
            exit(1)
          end
        end
        
        def start_server
          ::Rdb4o::Database.setup_server(config)
        end
        
        # Registering this ORM lets the user choose DataMapper as a session store
        # in merb.yml's session_store: option.
        def register_session_type
          Merb.register_session_type("rdb4o",
          "merb/session/rdb4o_session",
          "Using rdb4o database sessions")
        end
      end
    end
  end
end