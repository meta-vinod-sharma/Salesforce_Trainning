@isTest
public class TestFetchRecords {
   
    @testSetup
    static void testDataSetup()
    {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 1; i < 150; i++)
        {
            contacts.add(new Contact(lastName='test' + i , subject__c = 'English'));
        }
        insert contacts;
    }
    
    @isTest
    static void testGetRecordType() {        
        FetchRecords RCObject = new FetchRecords();
        QueryEditorController QCObject = new QueryEditorController();
        QCObject.query = 'SELECT Name FROM Contact' ;       
        RCObject.setQueryToExecute(QCObject.query);
        System.assertEquals(RCObject.getRecordType(),[SELECT Name FROM Contact LIMIT 5], 'Unexpected records retrieved');
        System.assertEquals(RCObject.lstFields.size(), 2, 'Not all fields of query are retrieved');                
    }
    
    @isTest
    static void testSortData() {
        FetchRecords RCObject = new FetchRecords();
        RCObject.setQueryToExecute('SELECT Name FROM Contact');
        RCObject.fName = 'Name' ;
        RCObject.sortData() ;
        System.assertEquals(RCObject.getRecordType(),[SELECT Name FROM Contact ORDER BY Name desc limit 5], 'records not sorted as expected');
    }
    
    @isTest
    static void testSortDataOnOrderedQuery() {
        FetchRecords RCObject = new FetchRecords();
        RCObject.setQueryToExecute('SELECT Name FROM Contact Order by Name');
        RCObject.fName = 'Id' ;
        RCObject.sortData() ;
        System.assertEquals(RCObject.getRecordType(),[SELECT Name FROM Contact ORDER BY Id desc limit 5], 'records not sorted as epected');
    }
 
}