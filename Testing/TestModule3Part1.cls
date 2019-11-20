@isTest
public class TestModule3Part1 {
    @isTest
    static void testStudentSearch(){
        Class__c cls = new Class__c(Name = 'A',MaxSize__c = 20);
        insert cls;
        List<Student__c> stds = new LIst<Student__c>();
        for(Integer i = 0;i<20;i++){
            stds.add(new Student__c(Name = 'Student '+i,Class__c = cls.Id));
        }
        insert stds;
        List<Student__c> students = Module3_Assignment1_Part1.studentsInClass(cls.Id);
        System.assertEquals(stds.size(), Students.size());
    }
    
    @isTest
    static void testStudentClassMap(){
        Class__c cls = new Class__c(Name = 'A',MaxSize__c = 20);
        insert cls;
        List<Student__c> stds = new LIst<Student__c>();
        for(Integer i = 0;i<20;i++){
            stds.add(new Student__c(Name = 'Student '+i,Class__c = cls.Id));
        }
        insert stds;
        Map<String, Set<ID>> studentClassMap = Module3_Assignment1_Part1.studentClassMap();
        Set<id> sts = studentClassMap.get(cls.Name);
        System.assertEquals(stds.size(), sts.size());
    }
    
    @isTest
    static void testNumberOfWorkingDays(){
        Date date1 = Date.newInstance(2019,11,1);
        Date date2 = Date.newInstance(2019,11,19);
        integer numberOfWorkingDays = Module3_Assignment1_Part1.numberOfWorkingDays(date1, date2);
        System.assertEquals(11,numberOfWorkingDays);
    }

}
