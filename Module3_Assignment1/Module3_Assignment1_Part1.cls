public class Module3_Assignment1_Part1 {
    public static List<SObject> studentInClass(ID classId){
        Student__c[] student = [SELECT FirstName__c
                               FROM Student__c 
                               WHERE Class__c = : classId];
        return student;
    }
    
    public static Map<String, List<ID>> studentClassMap(){
        list<Student__c> student = new list<Student__c>();
        student = [SELECT Class__r.Name,Id FROM Student__c];
        list<Class__c> classes = new list<Class__c>();
        classes = [SELECT Name FROM Class__c];
        Map<String, List<ID>> studentClass = new Map<String, List<ID>>();
        for(integer i = 0; i < classes.size(); i++){
            String class1 = classes[i].Name;
            list<ID> classA = new list<ID>();
            for(Integer j = 0; j < student.size(); j++){
                if(class1 == student[j].Class__r.Name){
                    classA.add(student[j].id);
                }
            }
            studentClass.put(class1,classA);
        }
        return studentClass;
    } 
    
    public static integer  numberOfWorkingDays(date date1,date date2){
        Integer workingDays = 0;
        for(integer i = 1; i <= date1.daysBetween(date2); i++)  
        {  
            Date dt = date1 + i;  
            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = currDate.format('EEEE');  
            if(todayDay != 'Saturday' && todayDay !='Sunday' )  
                {  
                    workingDays = workingDays + 1;  
                }     
               
        }  
              
     
        return workingDays; 
    }

}