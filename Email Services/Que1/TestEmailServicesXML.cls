@isTest
public class TestEmailServicesXML {
    
    @isTest
    public static void testHandleInboundEmail(){
        Messaging.InboundEmail email = new Messaging.InboundEmail(); 
        Messaging.InboundEnvelope envelop = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.TextAttachment textAttachment = new Messaging.InboundEmail.TextAttachment();
        textAttachment.fileName = 'ContactAttachment.xml';
        String contactXml = '<Contacts>'+
	                        	'<Contact>'+	
		                        	'<firstName>VIN1</firstName>'+
									'<lastName>Sharma</lastName>'+
                					'<department>CSE</department>'+
                					'<email>xyz12@metacube.com</email>'+
                					'<subject>Math</subject>'+
        					'</Contact>'+
							'<Contact>'+
								'<firstName>VIN2</firstName>'+
								'<lastName>Sharma</lastName>'+
                				'<department>ECE</department>'+
                				'<email>xyz123@metacube.com</email>'+
                				'<subject>English</subject>'+
							'</Contact>'+
							'<Contact>'+
								'<firstName>VIN3</firstName>'+
								'<lastName>Sharma</lastName>'+
                				'<department>ME</department>'+
                				'<email>xyz1234@metacube.com</email>'+
                				'<subject>English</subject>'+
							'</Contact>'+
        					'<Contact>'+
								'<firstName>VIN4</firstName>'+
								'<lastName>Sharma</lastName>'+
                				'<department>EE</department>'+
                				'<email>xyz12345@metacube.com</email>'+
                				'<subject>English</subject>'+
							'</Contact>'+
        			'</Contacts>';
        email.fromAddress = 'vinod.sharma@metacube.com';
        textAttachment.body = contactXml;
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { textAttachment };
        EmailServicesXML testingMail = new EmailServicesXML();
        testingMail.handleInboundEmail(email, envelop);
        List<Contact> contactsList = [SELECT FirstName, LastName, Email, Department, experience__c FROM Contact];
        System.assertEquals(4, contactsList.size(), 'Contacts were not inserted as expected.');
        System.assertEquals('VIN1', contactsList.get(0).FirstName, 'Contacts were not inserted as expected.');
    }
}