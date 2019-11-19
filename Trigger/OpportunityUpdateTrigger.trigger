/*
 * OpportunityUpdateTrigger on Opportunity Object populates close date as todays date if StageName is changed 
 *  from another value to CLOSED_WON or CLOSED_LOST
 */

trigger OpportunityUpdateTrigger on Opportunity (after update) {
    List<Opportunity> oppList = new List<Opportunity>();
    
    
    for (Opportunity oppty : [SELECT Id,Name,StageName FROM Opportunity WHERE Id IN :Trigger.New and (StageName = 'Closed Won' or StageName = 'Closed Lost') ]) {
        if(trigger.oldMap.get(oppty.id).StageName != oppty.StageName){
            oppty.CloseDate = System.today();
            oppList.add(oppty);
        }
        
    } 
    
    if (oppList.size() > 0) {
        update oppList;
    }
    
    
   
}