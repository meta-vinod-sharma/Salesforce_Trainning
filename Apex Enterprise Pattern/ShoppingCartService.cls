public class ShoppingCartService {
       
    public void getSelected(List<ProductWrapper> cartProducts, List<ProductWrapper> prodWrapList)
    {
        cartProducts.clear();
        for(ProductWrapper product1 : prodWrapList){
            if(product1.selected == true){
                cartProducts.add(product1);
            }
        }
    }
    public void selectedItems(List<ProductWrapper> cartProducts,Cart_Items__c cart){
        for(ProductWrapper pro : cartProducts){
            pro.product.Cart_Item__c = cart.Id;
        }
    }

    public void addProductToCart(List<ProductWrapper> cartProducts, List<ProductWrapper> cartprodWrapList){
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
    public void updateQuantity(ID prodWrapListId, Integer previousQuantity, List<ProductWrapper> cartProducts, List<ProductWrapper> prodWrapList){
        for(ProductWrapper pro : cartProducts){
            if(pro.quantity == 0 || pro.quantity < 0 || pro.quantity == NULL){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid Quantity'));
                pro.quantity = previousQuantity;
            }
            if(pro.quantity > pro.product.Quantity_Available__c + previousQuantity){
                Decimal temp = pro.product.Quantity_Available__c + previousQuantity;
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Quantity Less Then or equal '+ temp));
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
    
    public Decimal generateInvoice(List<ProductWrapper> cartProducts){
        Decimal grandTotal = 0.0;
        for(ProductWrapper pro : cartProducts){
            grandTotal += pro.Product.Price_Per_Unit__c * pro.quantity;
        }
        return grandTotal;
    }
    /*
     * Deletes Product from cart
     */
    public void deleteProduct(ID ProdId, List<ProductWrapper> cartProducts, List<ProductWrapper> cartprodWrapList, List<ProductWrapper> prodWrapList) {
        Integer pos1;
        Integer pos2;
        for(Integer j = 0;j < cartProducts.size();j++){
            if(cartProducts[j].product.id == ProdId){
                pos1 = j;
                break;
            }
        }
        
        for(Integer k = 0;k < cartprodWrapList.size();k++){
            if(cartprodWrapList[k].product.id == ProdId){
                pos2 = k;
                break;
            }
        }
        for(integer i =0 ;i < prodWrapList.size();i++){
            if(prodWrapList[i].product.Id == ProdId){
                prodWrapList[i].product.Quantity_Available__c += cartProducts[pos1].quantity;
                cartProducts.remove(pos1);
                cartprodWrapList.remove(pos2);
                break;
            }
        }

        
    }
    /*
     * Returns total of cart value
     */
    public Decimal getTotal(List<ProductWrapper> cartProducts){
        Decimal totalAmount = 0.0;
        for(ProductWrapper product : cartProducts){
            totalAmount += product.Product.Price_Per_Unit__c * product.quantity;
        }
        return totalAmount;
    } 
    
    public void addCartToPurchaseOrders(Decimal totalAmount, List<ProductWrapper> cartProducts){
        PurchaseOrder__c purchaseOrder = new PurchaseOrder__c(Total__c = totalAmount, Order_Status__c = 'Pending');
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
      (new ShoppingCartController()).sortByOrderStatus();
        insert cartItemList;
       update productList;
    }

}