public class EmailServicesXML implements Messaging.InboundEmailHandler {
    
    public string XMLString;
    public List<Contact> contactList = new List<Contact>();
    Contact con;
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        XMLString = email.textAttachments[0].body;
        	
		XMLparse();
        return result;
    }
    public void XMLparse(){
        DOM.Document doc=new DOM.Document();
        try{
            doc.load(XMLString);
            DOM.XmlNode rootNode=doc.getRootElement();
            parseXML(rootNode);
            contactList.add(con);
            insert contactList;
        }catch(exception e){
            system.debug(e.getMessage());
        }
    }
    
    private void parseXML(DOM.XMLNode node) {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            if(node.getName()=='Contact'){
                if(con!=null)
                    contactList.add(con);
                con = new Contact();
            }
            if(node.getName()=='firstName')
                con.firstName=node.getText().trim();
            if(node.getName()=='lastName')
                con.lastName=node.getText().trim();
            if(node.getName()=='department')
                con.Department=node.getText().trim();
            if(node.getName()=='Email')
                con.Email=node.getText().trim();
            if(node.getName()=='subject')
                con.subject__c=node.getText().trim();
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            parseXML(child);
        }
    }
}