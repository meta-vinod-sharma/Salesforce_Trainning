@isTest
public class TestQueryEditorController 
{
	@isTest
    static void testEmptyQuery() {
        QueryEditorController QCObj = new QueryEditorController();
        QCObj.query = '';
        QCObj.executeQuery();
        System.assertEquals(false, QCObj.renderResult, 'Error message  : Enter Query');
    }
    
	@isTest
    private static void testNonEmptyInCorrectQuery() {
        QueryEditorController QCObj = new QueryEditorController();
        QCObj.query = 'SELECT Nameee FROM Contact';
        QCObj.executeQuery();
        System.assertEquals(false, QCObj.renderResult, 'Error message  : Incorrect Query');
    }
    
    @isTest
    private static void testNonEmptyCorrectQuery() {
        QueryEditorController QCObj = new QueryEditorController();
        QCObj.query = 'SELECT Name FROM Contact';
        QCObj.executeQuery();
        System.assertEquals(true, QCObj.renderResult, 'Query Not executed successfully');
    }
}