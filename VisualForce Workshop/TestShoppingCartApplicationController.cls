@isTest
public class TestShoppingCartApplicationController {
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
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        System.assertEquals( purchaseOrders ,spcon.getPurchaseOrders(), 'All orders not fetched');
    }
    @isTest
    static void testGetProducts() {
        List<Product2> products = [SELECT Name,ProductCode,price_per_unit__c,quantity_available__c FROM Product2] ;
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        System.assertEquals( products.size() ,spcon.getProductRecords().size(), 'All products not fetched');
    }
    
    
    @isTest
    static void testAddPurchase() {
        List<Product2> products = [SELECT Name,ProductCode,price_per_unit__c,quantity_available__c FROM Product2 limit 10] ;
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.addPurchase();
        System.assertEquals( products.size() ,spcon.tempProducts.size(), 'All products not fetched');
    }
    
    @isTest
    static void testSearchProducts() {
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.ProductSearch = 'test1' ;
        List<Product2> products = [SELECT Name,ProductCode,Description,price_per_unit__c,quantity_available__c FROM Product2 WHERE NAME LIKE '%test1%'] ;
        spcon.getProductsSearch();
        System.assertEquals( products, spcon.tempProducts,'Search not giving correct results');
    }
    
    @isTest
    static void testAddProductToCart() {
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> cartProducts = spcon.cartProducts;
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
        for(Integer i = 0 ; i < 5 ; i++) {
            prodWrap[i].selected = true;
            cartProducts.add(prodWrap[i]);
        }
        spcon.addProductToCart();
        system.assertEquals( 5 , spcon.cartprodWrapList.size(),'Not all selected items added to cart');
    }
    
    @isTest
    static void testGenerateInvoice() {
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> cartProducts = spcon.cartProducts;
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
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
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> cartProducts = spcon.cartProducts;
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
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
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
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
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
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
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        spcon.getProducts();
        List<ShoppingCartApplicationController.productWrapper> prodWrap = spcon.getProducts();
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
        
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        List<PurchaseOrder__c> purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY id asc limit 1000] ;
        System.debug(purchaseOrders.size());
        spcon.sortByOrderPrice();
        purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY Total__c asc limit 1000] ;
        system.assertEquals(purchaseOrders, spcon.getPurchaseOrders(), 'Orders does not Sort according to Order price');
        spcon.sortByOrderPrice();
    } 
    
    @isTest
    static void testSortByOrderStatus() {
        
        ShoppingCartApplicationController spcon = new ShoppingCartApplicationController() ;
        List<PurchaseOrder__c> purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY id asc limit 1000] ;
        System.debug(purchaseOrders.size());
        spcon.sortByOrderStatus();
        purchaseOrders = [SELECT ID,Total__c,order_status__c FROM PurchaseOrder__c ORDER BY order_status__c asc limit 1000] ;
        system.assertEquals(purchaseOrders, spcon.getPurchaseOrders(), 'Orders does not Sort according to Order price');
        spcon.sortByOrderStatus();
    } 
    
}
