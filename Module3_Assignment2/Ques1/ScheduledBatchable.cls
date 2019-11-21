global class ScheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      SendMailToOwner b = new SendMailToOwner(); 
      database.executebatch(b);
   }
}