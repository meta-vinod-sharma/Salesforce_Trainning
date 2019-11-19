@isTest
public class TestTeacherInsertUpdateTrigger {
    
    @isTest
    static void TestInsertUpdateTeacherTrigger1(){        
    Contact t1 = new Contact(FirstName = 'Ashish',LastName = 'Sharma',Subject__c = 'Hindi');
    Test.startTest();
    Database.SaveResult result = Database.insert(t1, false);
    Test.stopTest();
    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals('Cannot Insert / Update because Subject = Hindi',
                             result.getErrors()[0].getMessage());
    }
    
    @isTest
    static void TestInsertUpdateTeacherTrigger2(){        
    Contact t2 = new Contact(FirstName = 'Rahul',LastName = 'Sharma',Subject__c = 'English');
    Test.startTest();
    Database.SaveResult result = Database.insert(t2, false);
    Test.stopTest();
    System.assert(result.isSuccess());
   
    }
}