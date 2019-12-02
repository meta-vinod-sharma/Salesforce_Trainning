public class QueryEditorController {
    
    public String query{get;set;}
    public boolean renderResult{get;set;}
    
    public QueryEditorController() {
        renderResult = false ;
    }
    
    public void executeQuery() {
        if(String.isBlank(query)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Query can not be empty'));
            return;
        }else {
            try {
                Database.query(query);
            }catch(QueryException ex) {
                ApexPages.addMessages(ex);
                return;
            }
            
        }
        renderResult = true;
    }
}