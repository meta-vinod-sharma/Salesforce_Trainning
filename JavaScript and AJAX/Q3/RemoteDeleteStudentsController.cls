public class RemoteDeleteStudentsController {
    
    public RemoteDeleteStudentsController(ApexPages.StandardSetController stdCon){
        
    }
    @RemoteAction
    public static void deleteStudents(ID [] selectedStudentsForDeletion){
        try
        {
            List<Database.DeleteResult> results = Database.delete(selectedStudentsForDeletion);
        }
        catch(Exception except)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, except.getMessage()));
        }
        
    }
    public Pagereference backToParentPage(){
        PageReference pageRef = new PageReference('/a04');
        pageRef.setRedirect(true);
        return pageRef;
    }

}