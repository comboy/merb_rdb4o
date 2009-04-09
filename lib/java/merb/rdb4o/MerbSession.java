package merb.rdb4o;

public class MerbSession {
   private String session_id;
   private String data;
   private java.util.Date updated_at;
   
   public MerbSession(String session_id, String session_data) {
     this.session_id = session_id; 
     this.data = session_data;
   }

   public MerbSession() {
      this.session_id = null;
      this.data = null;
      this.updated_at = null;
   }

   public String toString() {
      return "Session::"+this.session_id;
   }

   public void setSessionId(String x) {
      this.session_id = x;
   }
   public String getSessionId() {
      return this.session_id;
   }

   public void setData(String x) {
      this.data = x;
   }
   public String getData() {
      return this.data;
   }
   
   public java.util.Date getUpdatedAt() {
       return this.updated_at;
   }
   
   public void setUpdatedAt(java.util.Date x) {
       this.updated_at = x;
   }



}
