public class JSONController {
    public String JSONString {get;set;}

    public JSONController(){
        List<Student__c> students = [SELECT FirstName__c,Name,Age__c,Class__c,DOB__c,Married__c,Sex__c,Spouse__c FROM Student__c];
        JSONString = JSON.serialize(students);
        System.debug(JSONString);
    }
    
}