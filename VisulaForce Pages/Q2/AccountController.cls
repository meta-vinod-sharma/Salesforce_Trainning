public class AccountController {
    public String billingCity1{get; set;}
    public String billingState1{get; set;}
    public String billingCountry1{get; set;}
    public String numberOfAccountsToShow{get; set;}  
    public List<Account> accs{get; set;}
    public ApexPages.StandardSetController setCon {
        
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,BillingCity,BillingState,BillingCountry FROM Account 
                     WHERE BillingCity = : billingCity1 AND BillingState = : billingState1 AND BillingCountry = : billingCountry1 ]));
            }
            return setCon;
        }
        set;
    }
     public void getAccounts() {
         setCon = null;
         System.debug(BillingCity1);
         accs = (list<Account>)setCon.getRecords();
    }

    public void first() 
    {
        setcon.first();
        accs= (List<Account>)setCon.getRecords();
    }
    
    
    public void last() 
    {
        setcon.last();
        accs= (List<Account>)setCon.getRecords();
    }
    
    public void next() 
    {
        setcon.next();
        accs= (List<Account>)setCon.getRecords();
    }
    
    public void previous() 
    {
        setcon.previous();
        accs= (List<Account>)setCon.getRecords();
    }


}