module Merb::Orms::Rdb4o::Model
  def to_param
    key
  end
end
Rdb4o::Model.send(:include, Merb::Orms::Rdb4o::Model)