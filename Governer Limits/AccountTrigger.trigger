trigger AccountTrigger on Account (before delete, before insert, before update) {
    
    List<Opportunity> opptys = [select id, name, closedate, stagename from Opportunity where  accountId IN :Trigger.newMap.keySet() AND (StageName='ClosedLost' OR StageName='ClosedWon')];
    
    if(trigger.isdelete){
        
    }else {
        for(Opportunity op : opptys){
        if(true){
            System.debug('Do more logic here...');
        }
    }
    }
    
}