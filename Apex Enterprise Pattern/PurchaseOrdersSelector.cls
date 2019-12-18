public class PurchaseOrdersSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType(){
        return PurchaseOrder__c.getSObjectType();
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {PurchaseOrder__c.Id, PurchaseOrder__c.Total__c, PurchaseOrder__c.Order_Status__c};
    } 
    
    public List<PurchaseOrder__c> getAllPurchaseOrders(){
        String query = newQueryFactory().toSOQL();
        return (List<PurchaseOrder__c>) Database.query(query);
    }
    public List<PurchaseOrder__c> getAllPurchaseOrdersSorted(String orderBy,String sortDirection){
        String query = '';
        if(sortDirection == 'asc')
        {
            query = String.format('SELECT {0} FROM {1} ' + 'ORDER BY {2} ' + 'ASC',
                                  new List<String> {
                                      getFieldListString(),
                                          getSObjectName(),
                                          orderBy});
        }
        else
        {
            query = String.format('SELECT {0} FROM {1} ' + 'ORDER BY {2} ' + 'DESC',
                                  new List<String> {
                                      getFieldListString(),
                                          getSObjectName(),
                                          orderBy});
        }
        return (List<PurchaseOrder__c>) Database.query(query);
    }
}