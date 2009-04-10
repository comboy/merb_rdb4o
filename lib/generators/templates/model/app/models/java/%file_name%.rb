package app.models.java;
import com.rdb4o.Rdb4oModel;

public class <%= class_name %> extends Rdb4oModel {

  public <%= class_name %> () {
      // Set all stirng empty and all integers to 0
  }

<% attributes.each do |name, type| %>
  private <%= type %> <%= name %>;
  public void set<%= name.capitalize %>(<%=type %> <%= name %>) {
      this.<%= name %> = <%= name %>;
  }
  public <%= type %> get<%= name.capitalize %>() {
      return this.<%= name %>;
  }
  
<% end -%>
}