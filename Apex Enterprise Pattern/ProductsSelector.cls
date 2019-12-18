public class ProductsSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType(){
        return Product2.getSObjectType();
    }
    
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {Product2.Name, Product2.ProductCode, Product2.Price_Per_Unit__c, Product2.Quantity_Available__c};
    } 
    
    public List<Product2> getAllProducts(){
        String query = newQueryFactory().toSOQL();
        return (List<Product2>) Database.query(query);
    }

}