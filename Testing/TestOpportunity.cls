@isTest
public class TestOpportunity {
    @isTest
    static void testOpportunity()
    {
        Account acc = new Account(Name = 'ABC');
        Contact con = new Contact(LastName = 'Sharma', AccountId = acc.Id,Subject__c = 'English');
        insert con;
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today(),StageName = 'Closed Win',BillToContact__c = con.Id);
        oppList.add(op);
        insert oppList;
        OpportunityLookUp.updateOpportunities(oppList);
        List<Opportunity> oppoList = [SELECT Manager__c FROM Opportunity WHERE BillToContact__c =: con.id];
        System.assertEquals(acc.Id, oppoList.get(0).Manager__c);
    }

}