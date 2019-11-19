@isTest
public class TestStudentTrigger {
    @isTest
    static void testStudentTrigger1(){
        Class__c cls = new Class__c(Name = 'A', MaxSize__c = 10);
        insert cls;
        List<Student__c> stds = new List<Student__c>();
        for(Integer i = 0; i < 10;i++){
            stds.add(new Student__c(Name='Student '+i,Class__c = cls.id));
        }
        insert stds;
        Student__c st = new Student__c(Name = 'Student',Class__c = cls.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(st, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('class size is full',result.getErrors()[0].getMessage());
    }
    
    @isTest
    static void testStudentTrigger2(){
        Class__c cls = new Class__c(Name = 'A', MaxSize__c = 10);
        insert cls;
        List<Student__c> stds = new List<Student__c>();
        for(Integer i = 0; i < 9;i++){
            stds.add(new Student__c(Name='Student '+i,Class__c = cls.id));
        }
        insert stds;
        Student__c st = new Student__c(Name = 'Student',Class__c = cls.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(st, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }
    
    @isTest
    static void testStudentTrigger3(){
        Class__c cls = new Class__c(Name = 'A', MaxSize__c = 10);
        insert cls;
        List<Student__c> stds = new List<Student__c>();
        Student__c st = new Student__c(Name='Student',Class__c = cls.id);
        Test.startTest();
        Database.SaveResult result = Database.insert(st, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(1,[SELECT MyCount__c FROM Class__c where id =: cls.id].MyCount__c);
    }

}