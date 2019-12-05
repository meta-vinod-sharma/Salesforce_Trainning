@isTest
public class TestEmailSendOnOppUpdate {

    @isTest
    static void testOpportunityStageName1(){
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today().addDays(30),StageName = 'Prospecting');
        insert op;
        op.StageName = 'Qualification';
        Test.startTest();        
        Database.SaveResult result = Database.update(op, false);
        Integer invocation = Limits.getEmailInvocations();
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(1, invocation, 'Email dones not sent' );
    }
    @isTest
    static void testOpportunityStageName2(){
        Opportunity op = new Opportunity(Name = 'Oppo1',CloseDate = System.today().addDays(30),StageName = 'Prospecting');
        insert op;
        op.StageName = 'Prospecting';
        Test.startTest();
        Database.SaveResult result = Database.update(op, false);
        Integer invocation = Limits.getEmailInvocations();
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(0, invocation, 'Email dones not sent' );
    }
    
    


}