public class ListOfSObjects {
   public static List<String> getAllSObjectName(){
       List<string> sObjectList = new List<string>();
       for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
           sobjectList.add(objTyp.getDescribe().getName());
       }
       return sObjectList;
   }
}