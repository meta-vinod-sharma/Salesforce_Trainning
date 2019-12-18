public class ProductWrapper {
    
    public Product2 product{get; set;}
    public Boolean selected{get; set;}
    public Integer quantity{get;set;}
    public productWrapper(Product2 pro){
        product = pro;
        selected = false;
        quantity =1;
    }
    
    public ProductWrapper(){
        
    }
}