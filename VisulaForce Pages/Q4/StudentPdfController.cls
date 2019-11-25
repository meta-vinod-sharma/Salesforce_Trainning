public class StudentPdfController {
    
    public Id currentPageStudentId 
     {
         get
         {
             return Id.valueOf(ApexPages.currentPage().getParameters().get('Id'));
         }
         set;
     }
    
    public Student__c getStudents(){
        Student__c student = [SELECT FirstName__c,Name,Age__c,Class__c,DOB__c,Married__c,Sex__c,Spouse__c FROM Student__c WHERE Id = :currentPageStudentId];
        return student;
    }
    
    public PageReference savePdf() {

    PageReference pdf = Page.StudentDetailPdf1;
    pdf.getParameters().put('id',currentPageStudentId);

    Attachment attach = new Attachment();
    
        
    attach.Body = pdf.getContentAsPDF();
    attach.Name = 'StudentDetail.pdf';
    attach.ParentId = currentPageStudentId;
    List<Attachment> attachmentList = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :currentPageStudentId and Name='StudentDetail.pdf' ];
    if(attachmentList.size() > 0) 
    {
        delete attachmentList;
    }    
    insert attach;
    
    return new PageReference('/'+currentPageStudentId);

  }
}