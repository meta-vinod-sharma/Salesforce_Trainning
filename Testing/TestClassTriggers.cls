@isTest
public class TestClassTriggers {
    @isTest
    static void testClassStatus1(){
        Class__c cls = new Class__c(Name = 'A',Custom_Status__c = 'Open',MaxSize__c = 10);
        insert cls;
        List<Student__c> stds = new List<Student__c>();
        for(integer i = 0; i < 6; i++){
            stds.add(new Student__c(Name='Student ' + i, class__c = cls.id));
        }
        insert stds;
        cls.Custom_Status__c = 'Reset';
        Test.startTest();
        Database.SaveResult result = Database.update(cls, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(0, [Select COUNT() FROM Student__c WHERE class__c =: cls.id]);
    }
    @isTest
    static void testClassStatus2(){
        Class__c cls = new Class__c(Name = 'A',Custom_Status__c = 'Reset',MaxSize__c = 10);
        insert cls;
        List<Student__c> stds = new List<Student__c>();
        for(integer i = 0; i < 6; i++){
            stds.add(new Student__c(Name='Student ' + i, class__c = cls.id));
        }
        insert stds;
        cls.Custom_Status__c = 'Reset';
        Test.startTest();
        Database.SaveResult result = Database.update(cls, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assertEquals(6, [Select COUNT() FROM Student__c WHERE class__c =: cls.id]);
    }
    
    @isTest
    static void testClassFemale1(){
        Class__c cls = new Class__c(Name = 'A',Custom_Status__c = 'Reset',MaxSize__c = 10);
        insert cls;
        Student__c st1 = new Student__c(Name = 'Student 1',class__c = cls.id,Sex__c = 'Male');
        Student__c st2 = new Student__c(Name = 'Student 2',class__c = cls.id,Sex__c = 'Female');
        insert st1;
        insert st2;
        Test.startTest();
        Database.DeleteResult result = Database.delete(cls, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('one or more than one female available in class',result.getErrors()[0].getMessage());
    }
    
    @isTest
    static void testClassFemale2(){
        Class__c cls = new Class__c(Name = 'A',Custom_Status__c = 'Reset',MaxSize__c = 10);
        insert cls;
        Student__c st1 = new Student__c(Name = 'Student 1',class__c = cls.id,Sex__c = 'Male');
        Student__c st2 = new Student__c(Name = 'Student 2',class__c = cls.id,Sex__c = 'Male');
        insert st1;
        insert st2;
        Test.startTest();
        Database.DeleteResult result = Database.delete(cls, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        
    }

}