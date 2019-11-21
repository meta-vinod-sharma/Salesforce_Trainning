@isTest
public class TestRestrictContactByName {
    @isTest static void testInsertInvalidName1(){
       
        Contact con1 = new Contact(LastName = 'INVALIDNAME', subject__c='English');
        
       
         Test.startTest();
         Database.UpsertResult result1 = Database.upsert(con1, false);
         System.assert(!result1.isSuccess());
        System.assert(result1.getErrors().size() > 0);
      System.assertEquals('The Last Name "'+con1.LastName+'" is not allowed for DML',
                           result1.getErrors()[0].getMessage());
       
        Test.stopTest();

    }
    @isTest static void testInsertInvalidName2(){
       
        Contact con2 = new Contact(LastName = 'Sharma',subject__c='English');
        
         Test.startTest();
         upsert con2;
         Database.UpsertResult result2 = Database.upsert(con2, false);
         System.assert(result2.isSuccess());
        Test.stopTest();

    }
}