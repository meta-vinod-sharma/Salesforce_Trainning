public class Module3_Assignment1_Part1 {
    /*
     * Function studentsInClass takes a parameter of Id type and Returns a list of students in that class
    */
    
    public static List<Student__c> studentsInClass(ID classId){
        Student__c[] students = [SELECT FirstName__c
                               FROM Student__c 
                               WHERE Class__c = : classId];
        return students;
    }
    
    /*
     * Function studentClassMap returns a Map of Class id As key Class Name and a List of Student Ids of that Class
    */
    
    public static Map<String, Set<ID>> studentClassMap(){
        List<Student__c> student = new List<Student__c>();
        student = [SELECT Class__c,Class__r.Id,Id FROM Student__c];
        List<Class__c> classes = new List<Class__c>();
        classes = [SELECT id,Name FROM Class__c];
        Map<String, Set<ID>> studentClassMap = new Map<String, Set<ID>>();
        for(integer i = 0; i < classes.size(); i++){
            Id classId = classes[i].id;
            String className = classes[i].Name;
            Set<ID> studentsInClass = new Set<ID>();
            for(Integer j = 0; j < student.size(); j++){
                if(classId == student[j].Class__r.Id){
                    studentsInClass.add(student[j].id);
                }
            }
            studentClassMap.put(className,studentsInClass);
        }
        return studentClassMap;
    } 
    
    /*
     *  Function numberOfWorkingDays takes two dates as parameters 
     * And returns no of working days in between these two dates.
     */
    public static integer  numberOfWorkingDays(date date1,date date2){
        Integer workingDays = 0;
        for(Integer i = 1; i <= date1.daysBetween(date2); i++)  
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
