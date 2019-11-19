/*
 * TeacherInsertUpdateTrigger not allows a teacher to insert or update if he teaches Hindi
 */
trigger TeacherInsertUpdateTrigger on Contact (before insert, before update) {
    
    for(Contact con:Trigger.new){
        if(con.Subject__c.contains('Hindi')){
            con.addError('Cannot Insert / Update because Subject = Hindi');
        }
      
    }
        
     

   
    /*for (Contact teacher : [SELECT Id FROM Contact where Subject__c INCLUDES('Hindi') AND Id IN :Trigger.new]) {
       Trigger.newMap.get(teacher.Id).addError('Cannot Insert / Update because Subject = Hindi');
   }*/


  
}