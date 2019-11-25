public class OpportunityController {
    public id BillToContactFormula{get;set;}
     public Id currentPageOpportunityId 
     {
         get
         {
             return Id.valueOf(ApexPages.currentPage().getParameters().get('Id'));
         }
         set;
     }
    public List<SelectOption> getContacts(){
        List<SelectOption> contacts = new List<SelectOption>();
        Opportunity opportunity = [SELECT manager__c FROM Opportunity WHERE Id = :currentPageOpportunityId];
        List<Contact> contactsList = [SELECT Id,Name FROM Contact WHERE AccountId = :opportunity.Manager__c];
        for(Contact con : contactsList)
        {
            contacts.add(new SelectOption(con.Id, con.Name));
        }
        return contacts;
    }
    
    public PageReference save()
    {
        Opportunity opp = [SELECT BillToContact__c FROM Opportunity WHERE Id =: currentPageOpportunityId];
        opp.BillToContact__c = BillToContactFormula;
        update opp;
        return (new PageReference('/' + currentPageOpportunityId));
    }
    
    public PageReference clear()
    {
        Opportunity opp = [SELECT BillToContact__c FROM Opportunity WHERE Id =: currentPageOpportunityId];
        opp.BillToContact__c = null;
        update opp;
        return (new PageReference('/' + currentPageOpportunityId));
    }
    
    public PageReference cancel()
    {
        return (new PageReference('/' + currentPageOpportunityId));
    }
    

}