public class TaskScheduler {   
    public static void scheduleTask()
    {
        ScheduledBatchable sb = new ScheduledBatchable();
        String CRON = '0 0 1 * * ?';
        String jobID = System.schedule('Send Emails', CRON, sb);
    }
}