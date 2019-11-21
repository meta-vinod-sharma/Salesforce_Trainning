@isTest
public class TestAccountContact {
    @isTest
    static void testContactAccount1(){
        Account acc = new Account(Name = 'ABC');
        insert acc;
        id accId = acc.id;
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < 3; i++)
        {
            Contact con = new Contact(LastName = 'contact '+i, AccountId = accId);
            contactList.add(con);
        }
        insert contactList;
        String cntIds = contactList[0].id;
        for(integer i = 1; i < contactList.size();i++){
            cntIds = cntIds +  ',' + contactList[i].id;
        }
        System.assertEquals(cntIds, AccountContact.checkContactsInAccount(contactList[0].id));
    }
    
    @isTest
    static void testContactAccount2(){
       
        Account acc = new Account(Name = 'ABCD');
        insert acc;
        id accId = acc.id;
        Contact contact1 = new Contact(LastName = 'ASDF',AccountId = accId);
        insert contact1;
        acc.ContactIDs__c = contact1.id;
        update acc;
        Contact contact2 = new Contact(LastName = 'ASDFGH',AccountId = accId);
        insert contact2;
        String result = contact1.id;
        System.assertEquals(result, AccountContact.checkContactsInAccount(contact1.id));
    }
    
    @isTest
    static void testContactAccount3(){
       
        Account acc = new Account(Name = 'ABCD');
        insert acc;
        id accId = acc.id;
        Contact contact1 = new Contact(LastName = 'ASDF',AccountId = accId);
        insert contact1;
        acc.ContactIDs__c = contact1.id;
        update acc;
        Contact contact2 = new Contact(LastName = 'ASDFGH',AccountId = accId);
        insert contact2;
        String result = contact1.id +','+contact2.id;
        System.assertEquals(result, AccountContact.checkContactsInAccount(contact2.id));
    }

}