/*
 * OpportunityTrigger on Opportunity Object populates close date as todays date if StageName is changed 
 *  from another value to CLOSED_WON or CLOSED_LOST
 */

trigger OpportunityTrigger on Opportunity (before update, after update) 
{
    //When opportunity stage is changed to Closed Won OR Closed Lost.
    if(Trigger.isBefore)
    {
        for(Opportunity opp : Trigger.New)
        {   
            Opportunity oldOpportunity = Trigger.oldMap.get(opp.Id);
            if((oldOpportunity.StageName != 'Closed Won' && opp.StageName == 'Closed Won') || 
               (oldOpportunity.StageName != 'Closed Lost' && opp.StageName == 'Closed Lost'))
            {
                opp.CloseDate = System.today();
            }
        }
    }
    
    //When an opportunity's status is changed.
    if(Trigger.isAfter)
    {
        for(Opportunity opp : Trigger.New)
        {
            Opportunity oldOpportunity = Trigger.oldMap.get(opp.Id);
            if(opp.StageName != oldOpportunity.StageName)
            {
                EmailSendOnOppUpdate.sendEmailToOwner(opp);
            }
        }
    }
}