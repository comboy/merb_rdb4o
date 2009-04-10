Merb::Generators::ModelGenerator.template :model_rdb4o, :orm => :rdb4o do |t|
  t.source = File.dirname(__FILE__) / "templates/model/app/models/java/%file_name%.rb"
  t.destination = "app/models/java" / base_path / "#{file_name.capitalize}.java"
end
