@isTest
public class TestShoppingCartController {

    @testSetup
    static void setProductData() {
        List<Product2> products = new List<Product2>(); 
        for(Integer i = 0 ; i < 20 ; i ++ ) {
            products.add(new Product2(Name = 'test'+ i ,ProductCode = 'test00ASDF'+i ,price_per_unit__c = 399 + i ,quantity_available__c = 100 + i));
        }
        insert products;
    }
    @isTest
    static void testGetPurchaseOrders() {
        List<PurchaseOrder__c> purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY Id DESC] ;
        ShoppingCartController spcon = new ShoppingCartController() ;
        System.assertEquals( purchaseOrders ,spcon.getPurchaseOrders(), 'All orders not fetched');
    }
    @isTest
    static void testGetProducts() {
        List<Product2> products = [SELECT Name,ProductCode,price_per_unit__c,quantity_available__c FROM Product2] ;
        ShoppingCartController spcon = new ShoppingCartController();
        System.assertEquals( products.size() , (new ProductsSelector()).getAllProducts().size(), 'All products not fetched');
    }
    
    
    @isTest
    static void testAddPurchase() {
        List<Product2> products = [SELECT Name,ProductCode,price_per_unit__c,quantity_available__c FROM Product2 limit 10] ;
        ShoppingCartController spcon = new ShoppingCartController() ;
        spcon.addPurchase();
        System.assertEquals( products.size() ,spcon.tempProducts.size(), 'All products not fetched');
    }
    
    @isTest
    static void testSearchProducts() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.ProductSearch = 'test1' ;
        List<Product2> products = [SELECT Name,ProductCode,Description,price_per_unit__c,quantity_available__c FROM Product2 WHERE NAME LIKE '%test1%'] ;
        spcon.getProductsSearch();
        System.assertEquals( products, spcon.tempProducts,'Search not giving correct results');
    }
    
    @isTest
    static void testAddProductToCart() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> cartProducts = spcon.cartProducts;
        List<ProductWrapper> prodWrap = spcon.getProducts();
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
            cartProducts.add(prodWrap[i]);
        }
        spcon.addProductToCart();
        system.assertEquals( 5 , spcon.cartprodWrapList.size(),'Not all selected items added to cart');
    }
    
    @isTest
    static void testGenerateInvoice() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> cartProducts = spcon.cartProducts;
        List<ProductWrapper> prodWrap = spcon.getProducts();
        decimal total = 0.0;
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
            cartProducts.add(prodWrap[i]);
            total += prodWrap[i].quantity * prodWrap[i].product.Price_Per_Unit__c;
        }
        spcon.addProductToCart();
        spcon.generateInvoice();
        system.assertEquals(  total, spcon.grandTotal,'Not all selected items added to cart');
    }
    
    @isTest
    static void testDeleteProduct() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> cartProducts = spcon.cartProducts;
        List<ProductWrapper> prodWrap = spcon.getProducts();
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
            cartProducts.add(prodWrap[i]);
        }
        spcon.addProductToCart();
        spcon.prodId = spcon.cartProducts[0].product.Id;
        spcon.deleteProduct();
        system.assertEquals( 4 ,spcon.cartProducts.size(), 'Item not removed from cart');
    }
    
    @isTest
    static void testUpdateQuantity() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> prodWrap = spcon.getProducts();
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
        }
        spcon.addProductToCart();
        spcon.prodWrapListId = spcon.prodWrapList[0].product.Id;
        spcon.previousQuantity = spcon.prodWrapList[0].quantity;
        spcon.prodWrapList[0].product.quantity_available__c = 20;
        spcon.prodWrapList[0].quantity = 10;
        spcon.updateQuantity();
        system.assertEquals(11, spcon.prodWrapList[0].product.quantity_available__c,'Could not update product quantity');
    }
    
    @isTest
    static void testGetTotal() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> prodWrap = spcon.getProducts();
        Decimal total = 0.0;
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
            spcon.cartProducts.add(prodWrap[i]);
            total += prodWrap[i].quantity * prodWrap[i].product.Price_Per_Unit__c;
        }
       
        spcon.addProductToCart();
        spcon.addCartToPurchaseOrders();
        List<PurchaseOrder__c> purchaseOrders= [SELECT Id,Total__c FROM PurchaseOrder__c];
        system.assertEquals(total,purchaseOrders[0].Total__c , 'Total is not as expected');
    } 
    
    @isTest
    static void testPlaceOrder() {
        ShoppingCartController spcon = new ShoppingCartController();
        spcon.getProducts();
        List<ProductWrapper> prodWrap = spcon.getProducts();
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
        }
        spcon.addProductToCart();
        spcon.addCartToPurchaseOrders();
        List<PurchaseOrder__c> purchaseOrders= [SELECT Id FROM PurchaseOrder__c];
        system.assertEquals(1, purchaseOrders.size(), 'Order could not be placed');
    } 
    
    @isTest
    static void testSortByOrderPrice() {
        
        ShoppingCartController spcon = new ShoppingCartController();
        List<PurchaseOrder__c> purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY id asc limit 1000] ;
        System.debug(purchaseOrders.size());
        spcon.sortByOrderPrice();
        purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY Total__c asc limit 1000] ;
        system.assertEquals(purchaseOrders, spcon.getPurchaseOrders(), 'Orders does not Sort according to Order price');
        spcon.sortByOrderPrice();
    } 
    
    @isTest
    static void testSortByOrderStatus() {
        
        ShoppingCartController spcon = new ShoppingCartController();
        List<PurchaseOrder__c> purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY id asc limit 1000] ;
        System.debug(purchaseOrders.size());
        spcon.sortByOrderStatus();
        purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY order_status__c asc limit 1000] ;
        system.assertEquals(purchaseOrders, spcon.getPurchaseOrders(), 'Orders does not Sort according to Order price');
        spcon.sortByOrderStatus();
    }
}