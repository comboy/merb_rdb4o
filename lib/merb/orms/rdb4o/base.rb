module Merb::Orms::Rdb4o::Base
  def to_param
    key
  end
end
Rdb4o::Base.send(:include, Merb::Orms::Rdb4o::Base)