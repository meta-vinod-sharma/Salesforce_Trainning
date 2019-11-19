@isTest
public class TestClassFemaleDeleteTrigger {
    @isTest
    static void TestFeamleDeleteClassTrigger1(){
        Class__c cls = new Class__c(Name = 'A');
        insert cls;
        Student__c st = new Student__c(Name = 'Pass',Class__c = cls.id, Sex__c = 'Female');
        insert st;
        Student__c st2 = new Student__c(Name = 'Pass2',Class__c = cls.id, Sex__c = 'male');
        insert st2;
        Test.startTest();
       
        Database.DeleteResult result = Database.delete(cls, false);
        Test.stopTest();
       
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('one or more than one female available in class',
                             result.getErrors()[0].getMessage());
    }
    
    @isTest
    static void TestFeamleDeleteClassTrigger2(){
        Class__c cls = new Class__c(Name = 'B');
        insert cls;
        Student__c st1 = new Student__c(Name = 'Pass1',Class__c = cls.id, Sex__c = 'male');
        insert st1;
        Student__c st2 = new Student__c(Name = 'Pass2',Class__c = cls.id, Sex__c = 'male');
        insert st2;
        Test.startTest();
        Database.DeleteResult result = Database.delete(cls, false);
        Test.stopTest();
       
        System.assert(result.isSuccess());
     }
        
        

}