public class ShoppingCartController {
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
    public String orderBy{get;set;}
    public Decimal totalAmount;
    
    
    
    public List<ProductWrapper> prodWrapList{get;set;}
    public List<ProductWrapper> cartprodWrapList{get;set;}
    public Cart_Items__c cart{get;set;}
    public List<Product2> tempProducts{get;set;}
    public List<ProductWrapper> cartProducts{get;set;}

    
    public ShoppingCartService shoppingCartServiceObj;
    public ProductWrapper productWrapperObj;

    /* 
     * Constructor for Initialization
     */
    public ShoppingCartController() {
        shoppingCartServiceObj = new ShoppingCartService();
        productWrapperObj = new ProductWrapper();
        prodWrapList= new List<ProductWrapper>();
        cartprodWrapList = new List<ProductWrapper>();
        tempProducts = new List<Product2>();
        cartProducts = new List<ProductWrapper>();
        cart = new Cart_Items__c();
        renderProduct = false;
        renderCart = false;
        totalAmount = 0.0;
        renderInvoice = false;
        MakeItReadOnly = false;
        sortDirection = 'asc';
        productMap = new map<id,ProductWrapper>();
        for(product2 product : new ProductsSelector().getAllProducts() ){
            productMap.put(product.Id, new ProductWrapper(product));
        }
    }
    
    public ApexPages.StandardSetController setCon {        
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(new ProductsSelector().getAllProducts());
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
                setConPurchaseHistory = new ApexPages.StandardSetController(new PurchaseOrdersSelector().getAllPurchaseOrders());
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
        setConPurchaseHistory = new apexPages.StandardSetController(new PurchaseOrdersSelector().getAllPurchaseOrdersSorted('Total__c',sortDirection));
        
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
        setConPurchaseHistory = new apexPages.StandardSetController(new PurchaseOrdersSelector().getAllPurchaseOrdersSorted('Order_Status__c',sortDirection));
        
    }
    
    /*
     * Returns List of purchase order List
     */
    Public list<PurchaseOrder__c> getPurchaseOrders() {
        return (list<PurchaseOrder__c>)setConPurchaseHistory.getRecords() ;
    }
    
    public void addPurchase(){
        renderInvoice = false;
        renderCart = false;
        renderProduct = true;
        cartprodWrapList.clear();
        cartProducts.clear();
        tempProducts.clear();
        for(Product2 product : (List<Product2>)setcon.getRecords()){
            tempProducts.add(productMap.get(product.Id).product);
        }
    }
    /*
     * REturns list of product wrapper which stores quantity of product and product
     */
    Public List<ProductWrapper> getProducts() {
        prodWrapList.clear();
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
        setCon = NULL;
        setCon = new ApexPages.StandardSetController(tempProducts);
    }
    
    public void getSelected()
    {
        shoppingCartServiceObj.getSelected(cartProducts,prodWrapList);
        
    }
    public void selectedItems(){
        shoppingCartServiceObj.selectedItems(cartProducts,cart);
        
    }

    public void addProductToCart(){
        shoppingCartServiceObj.addProductToCart(cartProducts,cartprodWrapList);
        MakeItReadOnly = false;
        renderCart = true;
        
    }
    
    public void setPreviousQuantity(){
        
    }
    
     /*
      * Update Available quantity of Product
      */   
    public void updateQuantity(){
        shoppingCartServiceObj.updateQuantity(prodWrapListId, previousQuantity, cartProducts, prodWrapList);
        
    }
    
    public void generateInvoice(){
        grandTotal = shoppingCartServiceObj.generateInvoice(cartProducts);
        renderInvoice = true;
        renderProduct = false;
        MakeItReadOnly = true;
        
    }
    /*
     * Deletes Product from cart
     */
    public void deleteProduct() {
        shoppingCartServiceObj.deleteProduct(ProdId, cartProducts, cartprodWrapList, prodWrapList);

        if(cartprodWrapList.size() == 0){
            renderCart = false;
        }
        
    }

    
    public void addCartToPurchaseOrders(){
        totalAmount = shoppingCartServiceObj.getTotal(cartProducts);
        shoppingCartServiceObj.addCartToPurchaseOrders(totalAmount, cartProducts);
        renderInvoice = false;
        renderCart = false;
        setConPurchaseHistory = null;
    } 
          
   
   
}
