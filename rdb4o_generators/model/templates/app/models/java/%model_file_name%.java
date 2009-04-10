
package app.models.java;
import com.rdb4o.Rdb4oBase;

public class <%= model_class_name %> extends Rdb4oBase {

  public <%= model_class_name %> () {
      // Set all stirng empty and all integers to 0
  }

<% model_attributes.each do |attr| -%>
<% p_type = attr.last -%>
<% p_name = attr.first -%>
  <%= "private #{p_type} #{p_name};" %>
          
  public void set<%= p_name.capitalize %>(<%=p_type %> <%= p_name %>) {
      <%= "this.#{p_name} = #{p_name};" %>
  }

  public <%= p_type %> get<%= p_name.capitalize %>() {
      <%= "return this.#{p_name};" %>
  }


<% end -%>

}        