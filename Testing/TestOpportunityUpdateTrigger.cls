@isTest
public class TestOpportunityUpdateTrigger {
    @isTest
    static void testOpportunityStageName1(){
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today().addDays(30),StageName = 'Prospecting');
        insert op;
        op.StageName = 'Closed Won';
        Test.startTest();
        Database.SaveResult result = Database.update(op, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(System.today(), [Select CloseDate FROM Opportunity WHERE Opportunity.id =: op.id].CloseDate);
    }
    @isTest
    static void testOpportunityStageName2(){
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today().addDays(30),StageName = 'Prospecting');
        insert op;
        op.StageName = 'Closed Lost';
        Test.startTest();
        Database.SaveResult result = Database.update(op, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(System.today(), [Select CloseDate FROM Opportunity WHERE Opportunity.id =: op.id].CloseDate);
    }
    
    @isTest
    static void testOpportunityStageName3(){
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today().addDays(30),StageName = 'Closed Won');
        insert op;
        op.StageName = 'Closed Won';
        Test.startTest();
        Database.SaveResult result = Database.update(op, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(System.today().addDays(30), [Select CloseDate FROM Opportunity WHERE Opportunity.id =: op.id].CloseDate);
    }

}