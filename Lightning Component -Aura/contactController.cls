public with sharing class contactController {
    
    @AuraEnabled
    public static Contact saveContact(Contact con) {
        upsert con ;
        return con ;
    }
}