
require 'base64'


module Merb

  MerbSession = Java::merb::rdb4o::MerbSession

  module SessionMixin
    def setup_session      
      before_value = cookies[_session_id_key]
      request.session, cookies[_session_id_key] = Merb::MerbSession.persist(cookies[_session_id_key])
      @_fingerprint = Marshal.dump(request.session.data).hash
      @_new_cookie = cookies[_session_id_key] != before_value
    end

    def finalize_session
      request.session.save if @_fingerprint != Marshal.dump(request.session.data).hash
      set_cookie(_session_id_key, request.session.session_id, Time.now + _session_expiry) if (@_new_cookie || request.session.needs_new_cookie)
    end

    def session_store_type
      "rdb4o"
    end
  end  
  
  
  class MerbSession 
    include Rdb4o::Base
    attr_accessor :needs_new_cookie
  
    class << self
      # Generates a new session ID and creates a row for the new session in the database.
      def generate
        create(:session_id => Merb::SessionMixin::rand_uuid, :data =>{})
      end
    
      # Gets the existing session based on the <tt>session_id</tt> available in cookies.
      # If none is found, generates a new session.
      def persist(session_id)
        if session_id
          #puts "there is"
          session = Merb::MerbSession.find_by_session_id session_id #self[session_id]          
          #puts session
        end
        unless session
          #puts "there's no"
          session = generate
        end
        [session, session.session_id]
      end

      def marshal(data) Base64.encode64(Marshal.dump(data)) if data end
      def unmarshal(data) Marshal.load(Base64.decode64(data)) if data end
    end
  
    # Regenerate the Session ID
    def regenerate
      self.session_id = Merb::SessionMixin::rand_uuid
      self.needs_new_cookie = true
      self.save
    end 
  
    # Recreates the cookie with the default expiration time 
    # Useful during log in for pushing back the expiration date 
    def refresh_expiration
      self.needs_new_cookie = true
    end
  
    # Lazy-delete of session data 
    def delete(key = nil)
      key ? self.data.delete(key) : self.data.clear
    end
    
    def empty?
      data.empty?
    end
  
    def each(&b)
      data.each(&b)
    end
    
    def [](key)
      data[key]
    end
  
    def []=(key, val)
      data[key] = val
    end
  
    def data
      @unmarshalled_data || @unmarshalled_data = self.class.unmarshal(@data)
    end
    
    def data=(data)
      @data, @unmarshalled_data = data, data
    end
  
  private
    
    before_save :serialize_data
    
    def serialize_data
      @data = self.class.marshal(self.data)
    end    
  end
  
#  class DataMapperSession < DataMapper::Base
#    
#    set_table_name "sessions"
#    property :session_id, :string, :length => 255, :lazy => false, :key => true
#    property :data,       :text, :lazy => false
#    property :updated_at, :datetime
#  
#
#  end

  
end
