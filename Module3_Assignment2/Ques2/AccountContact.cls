public class AccountContact {
   /*
    *Function checkContactsInAccount takes an Contact Id As parameter and return List of all contact ids linked to that account
    */
   public static String checkContactsInAccount(ID cntId){
       
       ID accountId = [SELECT Account.ID  FROM Contact WHERE ID =:cntId][0].Account.ID;
       Account acc = [SELECT Name , ContactIds__c FROM Account WHERE ID =: accountId];
       String cntIds = acc.ContactIds__c;
       
       if(cntIds == null){
           list<Contact> cts = [SELECT ID FROM Contact WHERE ACCOUNT.ID =: accountId];
           cntIds = cts[0].ID;
           for(Integer i=1;i<cts.size();i++){
               cntIds = cntIds +  ',' + cts[i].ID ;
               
           }
       }else{
           if(!cntIds.contains(cntId)){
               cntIds+=cntId;
           }
       }
       acc.ContactIds__c = cntIds;
       update acc;
       return cntIds;
   }
}