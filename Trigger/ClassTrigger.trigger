/*
 * ClassTrigger On class object not allow to delete class if class contains atleast one female and 
 * IF class Status is changed to Reset then delete that class
 */

trigger ClassTrigger on Class__c (before delete,after update) {
    if(trigger.isBefore){
        List<Class__c> cls = [SELECT id, (Select Class__c from students__r where sex__c = 'Female') From class__c where id IN :trigger.old];
        for(Class__c cls1: cls){
            if(cls1.students__r.size() >= 1){
                trigger.oldmap.get(cls1.id).addError('one or more than one female available in class');
            }
        }
    }
    if(trigger.isAfter){
        for(Class__c cls : [select Id,Custom_Status__c from Class__c where Id in : Trigger.New and Custom_Status__c = 'Reset']){
            if(trigger.oldMap.get(cls.id).Custom_Status__c != cls.Custom_Status__c){
                delete cls;
            }
        }
    }

}
