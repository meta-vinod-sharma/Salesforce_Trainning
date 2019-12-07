trigger AccountTestTrigger on Account (before insert,before update) {
    
    List<Contact> contactList = [select id, salutation, firstname, lastname, email from Contact WHERE accountId IN :Trigger.New];
    
      for(Contact c: contactList) {
         System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '],LastName[' + c.lastname +']');
         c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
 	      	                  	      
   }
    update contactList;

}