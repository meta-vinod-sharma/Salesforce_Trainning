public class ShoppingCartApplicationController {
    public List<Product2> productList{get; set;}
    public boolean renderProduct{get;set;}
    public boolean renderCart{get;set;}
    public boolean renderInvoice{get;set;}  
    public boolean MakeItReadOnly {get;set;}
    public String productSearch{get; set;}
    public Id ProdId{get;set;}
    public Integer previousQuantity{get;set;}
    public Id prodWrapListId{get;set;}
    public Decimal grandTotal{get;set;}
    public map<id,ProductWrapper> productMap;
    public String sortDirection {get;set;}
    
    
    
    public List<ProductWrapper> prodWrapList{get;set;}
    public List<ProductWrapper> cartprodWrapList{get;set;}
    public Cart_Items__c cart{get;set;}
    public List<Product2> tempProducts{get;set;}
    public List<ProductWrapper> cartProducts{get;set;}


    /* 
     * Constructor for Initialization
     */
    public ShoppingCartApplicationController() {
        prodWrapList= new List<ProductWrapper>();
        cartprodWrapList = new List<ProductWrapper>();
        tempProducts = new List<Product2>();
        cartProducts = new List<ProductWrapper>();
        cart = new Cart_Items__c();
        renderProduct = false;
        renderCart = false;
        renderInvoice = false;
        MakeItReadOnly = false;
        sortDirection = 'asc';
        productMap = new map<id,ProductWrapper>();
        for(product2 product : getProductRecords() ){
            productMap.put(product.Id, new ProductWrapper(product));
            system.debug(productMap.get(product.Id));
        }
    }
    /*
     * Return List of Products available in Product2 Object
     */
    public List<Product2> getProductRecords(){
        return [SELECT Name,ProductCode,Price_Per_Unit__c,Quantity_Available__c FROM Product2];
    }
    
    /*
     * StandardSetController property for getting data of Products from database and setting page size
     */ 
    public ApexPages.StandardSetController setCon {        
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,ProductCode,Price_Per_Unit__c,Quantity_Available__c FROM Product2  ]));
            }
            setcon.setPageSize(10);
            return setCon;
        }
        set;
    }
     /*
     * StandardSetController property for getting data of Purchase Order History from database and setting page size
     */
    public ApexPages.StandardSetController setConPurchaseHistory {        
        get {
            if(setConPurchaseHistory == null) {
                setConPurchaseHistory = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id,Total__c,Order_Status__c FROM PurchaseOrder__c]));
            }
            setConPurchaseHistory.setPageSize(10);
            return setConPurchaseHistory;
        }
        set;
    }
    /*
     * sort purchase order history according to Order price
     */
    public void sortByOrderPrice()
    {
        setConPurchaseHistory = null;
        if(sortDirection == 'asc')
        {
            sortDirection = 'desc';
        }
        else if(sortDirection == 'desc')
        {
            sortDirection = 'asc';
        }
        String query = 'SELECT Id,Total__c,Order_Status__c FROM PurchaseOrder__c ORDER BY Total__c '+ sortDirection;
        setConPurchaseHistory = new apexPages.StandardSetController(Database.getQueryLocator(query));
        
    }
    
    /*
     * sort purchase order history according to Order Status
     */
    public void sortByOrderStatus()
    {
        setConPurchaseHistory = null;
        if(sortDirection == 'asc')
        {
            sortDirection = 'desc';
        }
        else if(sortDirection == 'desc')
        {
            sortDirection = 'asc';
        }
        String query = 'SELECT Id,Total__c,Order_Status__c FROM PurchaseOrder__c ORDER BY Order_Status__c '+ sortDirection;
        setConPurchaseHistory = new apexPages.StandardSetController(Database.getQueryLocator(query));
        
    }
    
    /*
     * Returns List of purchase order List
     */
    Public list<PurchaseOrder__c> getPurchaseOrders() {
        return (list<PurchaseOrder__c>)setConPurchaseHistory.getRecords() ;
    }
    
    public void addPurchase(){
        renderProduct = true;
    }
    /*
     * REturns list of product wrapper which stores quantity of product and product
     */
    Public List<ProductWrapper> getProducts() {
        prodWrapList.clear();
        system.debug(productMap.values());
        for(Product2 product : (List<Product2>)setcon.getRecords()){
            
            prodWrapList.add(productMap.get(product.Id));
        }
        return prodWrapList;
    }
    /*
     * Stores product in list according to search
     */
    public void getProductsSearch(){
        prodWrapList.clear();
        tempProducts.clear();
        for(id productId : productMap.keySet()){
            if(productMap.get(productId).product.Name.containsIgnoreCase(productSearch)) {
                prodWrapList.add(productMap.get(productId));
                tempProducts.add(productMap.get(productId).product);
            }
        }
        setCon = new ApexPages.StandardSetController(tempProducts);
    }
    
    public void getSelected()
    {
        cartProducts.clear();
        for(ProductWrapper product1 : prodWrapList){
            if(product1.selected == true){
                cartProducts.add(product1);
            }
        }
    }
    public void selectedItems(){
        for(ProductWrapper pro : cartProducts){
            pro.product.Cart_Item__c = cart.Id;
        }
    }

    public void addProductToCart(){
        renderCart = true;
        for(ProductWrapper pro : cartProducts){
            if(pro.product.Quantity_Available__c > 0){
                if(cartprodWrapList.contains(pro)){
                    pro.quantity = pro.quantity + 1;
                }
            else{
                cartprodWrapList.add(pro);
            }
                pro.product.Quantity_Available__c -= 1;
            }
        }
    }
    
    public void setPreviousQuantity(){
        
    }
    
     /*
      * Update Available quantity of Product
      */   
    public void updateQuantity(){
        System.debug(previousQuantity);
        for(ProductWrapper pro : cartProducts){
            if(pro.quantity == 0 || pro.quantity < 0){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid Quantity'));
                pro.quantity = previousQuantity;
            }
        }
        
        for(integer i =0 ;i < prodWrapList.size();i++){
            if(prodWrapList[i].product.Id == prodWrapListId){
                prodWrapList[i].Product.Quantity_Available__c += previousQuantity - prodWrapList[i].quantity;
                break;
            }
        }
    }
    
    public void generateInvoice(){
        renderInvoice = true;
        renderCart = false;
        renderProduct = false;
        MakeItReadOnly = true;
        grandTotal = 0.0;
        for(ProductWrapper pro : cartProducts){
            grandTotal += pro.Product.Price_Per_Unit__c * pro.quantity;
        }
    }
    /*
     * Deletes Product from cart
     */
    public void deleteProduct() {
        Integer pos;
        for(Integer j = 0;j < cartProducts.size();j++){
            if(cartProducts[j].product.id == ProdId){
                pos = j;
                break;
            }
        }
        for(integer i =0 ;i < prodWrapList.size();i++){
            if(prodWrapList[i].product.Id == ProdId){
                prodWrapList[i].product.Quantity_Available__c += cartProducts[pos].quantity;
                cartProducts.remove(pos);
                break;
            }
        }
    }
    /*
     * Returns total of cart value
     */
    public Decimal getTotal(){
        Decimal totalAmount = 0.0;
        for(ProductWrapper product : cartProducts){
            totalAmount += product.Product.Price_Per_Unit__c * product.quantity;
        }
        return totalAmount;
    } 
    
    public void addCartToPurchaseOrders(){
        PurchaseOrder__c purchaseOrder = new PurchaseOrder__c(Total__c = getTotal(), Order_Status__c = 'Pending');
        insert purchaseOrder;
        List<Cart_Items__c> cartItemList = new List<Cart_Items__c>();
        List<Product2> productList = new List<Product2>();
        
        for(ProductWrapper product : cartProducts) {
           cartItemList.add(new Cart_Items__c(PurchaseOrder__c = purchaseOrder.Id ,
                                                                      Products__c = product.product.Id ,
                                                                      Ordered_Quantity__c = product.quantity ));
           product.product.Quantity_Available__c = product.product.Quantity_Available__c;
           productList.add(product.product);
       }
       renderInvoice = false;
        renderCart = false;
        sortByOrderStatus();
        insert cartItemList;
       update productList;
    } 
          
   
    
     public class ProductWrapper
   {
       public Product2 product{get; set;}
       public Boolean selected{get; set;}
       public Integer quantity{get;set;}
       public productWrapper(Product2 pro){
           product = pro;
           selected = false;
           quantity =1;
       }
   }
}