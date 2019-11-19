@isTest
public class TestTaskSchedular {
    @IsTest
    public static void mailTest()
    {
        List<Opportunity> opp = new List<Opportunity>();
        for (Integer i=0; i<10; i++) {
            Opportunity op = new Opportunity(Name = 'Opportunity ' + i,CloseDate = Date.today().addDays(-25),StageName = 'Closed Won');
            opp.add(op);
        }
        insert opp;
        Map<Id, Opportunity> oppoMap = new Map<Id, Opportunity>(opp);
        List<Id> oppIds = new List<Id>(oppoMap.keySet());
        Test.startTest();
        ScheduledBatchable sb = new ScheduledBatchable();
        String mailId = System.Schedule('Send Emails' , '0 0 * * * ?',sb);
        Test.stopTest();
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId IN :oppIds];
        System.assertEquals(oppIds.size(), tasks.size());
    }

}