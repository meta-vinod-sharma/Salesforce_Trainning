public class EmailSendOnOppUpdate {
    
    
    public static void sendEmailToOwner(Opportunity opportunity){
        EmailTemplate et = [SELECT Id,subject,body FROM EmailTemplate WHERE Name = 'OppEmailTemplate'];
        List<String> toAddress = new List<String>();
        String ownerMail = [SELECt email FROM User Where Id =: opportunity.OwnerId ].email;
        toAddress.add(ownerMail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            mail.setToAddresses(toAddress);
            mail.setSubject(et.subject);
            mail.setHTMLBody(et.Body);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        System.debug('HIIII');
        try {
            System.debug('Byyyee');
            Messaging.sendEmail(allmsg,false);
            System.debug('yyyyyy');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
}