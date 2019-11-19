/*
 * StudentTrigger on student Object not allow to 
 * Insert student in class if maxSize = NumberOfStudents
 * Populate MyCount Field in class when student is added in that class
 */ 

trigger StudentTrigger on Student__c (before insert,after insert, after update) {
    List<Class__c> clsList = new List<Class__c>();
    Map<Id,Class__c> cls = new Map<Id,Class__c>();
    List<Class__c> classes = [select id,NumberOfStudents__c,MaxSize__c from Class__c];
    for(Class__c cls1: classes){
        cls.put(cls1.Id, cls1);
    }
    if(trigger.isInsert){
        if(trigger.isBefore){
            for(Student__c st: Trigger.New){
                Class__c stCls = cls.get(st.Class__c);
                if(stCls.NumberOfStudents__c> = stCls.MaxSize__c){
                    st.addError('class size is full');
                }
            }
        }
        if(trigger.isAfter){
            for(Class__c clas : [SELECT MyCount__c FROM Class__c WHERE id IN (SELECT Class__c FROM Student__c WHERE id IN:Trigger.New)]){
                if(clas.MyCount__c==null){
                    clas.MyCount__c=1;
                }else{
                    clas.MyCount__c++;
                }
                clsList.add(clas);
            }  
        }
    }
    if(Trigger.isUpdate){
            if(Trigger.isBefore){
                for(Class__c clas : [SELECT MyCount__c FROM Class__c WHERE id IN (SELECT Class__c FROM Student__c WHERE id IN:Trigger.old)]){
                    clas.MyCount__c--;
                    clsList.add(clas);
                }
            }
            if(Trigger.isAfter){
                for(Class__c clas : [SELECT MyCount__c FROM Class__c WHERE id IN (SELECT Class__c FROM Student__c WHERE id IN:Trigger.New)]){
                    clas.MyCount__c++;
                    clsList.add(clas);
                }
            }
    }
    upsert clsList;
}