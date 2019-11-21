public class OpportunityLookup {
	/*
	 * Function updateOpportunities takes a list of Opportunities and papulate manager field by related account if BillToContact field is not Null 
	 * and manager field is Null
	 */
    public static void updateOpportunities(List<Opportunity> Opportunities)
    {
        List<Opportunity> oppo = new List<Opportunity>();
        for(Opportunity opp: Opportunities)
        {
            if(opp.BillToContact__c != null && opp.Manager__c == null)
            {
                opp.Manager__c = opp.BillToContact__r.AccountId;
                oppo.add(opp);
            }
        }
        upsert oppo;
    }
}