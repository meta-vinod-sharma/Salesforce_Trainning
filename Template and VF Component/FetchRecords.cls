public class FetchRecords {
    
    public String queryToExecute;
    public String finalQuery ;
    public List<string> lstFields {get; set;}
    public String fName{get;set;}
    public String direction;
    public boolean RenderMessage{get;set;}
    
    public FetchRecords() {
        QueryToExecute = '';
        finalQuery = '';
        setCon = null ;
        direction = 'asc';
        RenderMessage = false;
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                try {
                    setCon = new ApexPages.StandardSetController(Database.query(finalQuery));
                    setCon.setPageSize(5);
                }catch(QueryException ex) {
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.WARNING,'Enter valid Query'));
                    RenderMessage = true;
                }

            }
            return setCon;
        }
        set;
    }
    
    public String getQueryToExecute() {
        return this.queryToExecute;
    }
    
    public void setQueryToExecute(String QueryString) {
        if(!this.QueryToExecute.equalsIgnoreCase(QueryString)) {
            this.QueryToExecute = QueryString;
            this.setCon = null;
            finalQuery = QueryToExecute;
            RenderMessage = false;
        } 
    }
    
    public List<Sobject> getRecordType() {
        List<Sobject> QueryResult;
        try{
            QueryResult = setCon.getRecords();
        }catch(Exception ex){
            return null;
        }
        Set<string> setFields = new Set<String>();
        for(integer i = 0 ; i < QueryResult.size() ; i++){
            setFields.addAll(QueryResult[i].getPopulatedFieldsAsMap().keySet());
        }
        lstFields = new List<String>();
        lstFields.addAll(setFields); 
        return QueryResult;
    }
    
    public void sortData() {
        
        if(finalQuery.containsIgnoreCase('ORDER BY')) {
            finalQuery = finalQuery.substring(0, finalQuery.indexOfIgnoreCase('order by') - 1);
        }
        sortDirection();
        finalQuery = finalQuery + ' ORDER BY ' + this.fName + ' '+ direction ;  
        setCon = null;
    }
    public void sortDirection(){
        if(direction == 'asc'){
            direction = 'desc';
        }
        else{
            direction = 'asc';
        }
    }
    
}
