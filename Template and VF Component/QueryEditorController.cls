public class QueryEditorController {
    
    public String query{get;set;}
    public boolean renderResult{get;set;}
    
    public QueryEditorController() {
        renderResult = false ;
    }
    
    public void executeQuery() {
        if(String.isBlank(query)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Query can not be empty'));
            renderResult = false;
            return;
        }
        renderResult = true;
    }
}
