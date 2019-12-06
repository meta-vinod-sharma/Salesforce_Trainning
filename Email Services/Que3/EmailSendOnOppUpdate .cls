public class EmailSendOnOppUpdate {
    
    
    public static void sendEmailToOwner(Opportunity opportunity,String preStage,String newStage){
        EmailTemplate et = [SELECT Id,subject,body FROM EmailTemplate WHERE Name = 'OppEmailTemplate'];
        List<String> toAddress = new List<String>();
        User owner = [SELECt email, Name FROM User Where Id =: opportunity.OwnerId ];
        String ownerName = owner.Name;
        String ownerMail = owner.Email;
        toAddress.add(ownerMail);
      	String plainBody = et.Body;
        plainBody = plainBody.replace('{!Opportunity.OwnerFullName}', ownerName);
        plainBody += '\n';
    	plainBody = plainBody.replace('{!Opportunity.StageName1}', preStage);
    	plainBody = plainBody.replace('{!Opportunity.StageName2}', newStage);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            mail.setToAddresses(toAddress);
            mail.setSubject(et.subject);
            mail.setPlainTextBody(plainBody);
            mail.setHTMLBody(plainBody);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        try {
            Messaging.sendEmail(allmsg,false);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
}
