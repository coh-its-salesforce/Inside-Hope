@isTest
public class Test_COH_EmailEscalatetoManagerBatch {
    static testmethod void validateRecords(){
        //Timelapse_between_RA_Req_and_Resp__c Manager_Risk_Assessment_Request_Sent__c DateTime.now().addDays(-1)
        String NEWUSER_EMP_ID = '101010';
        contact_trace_Loader__c ctl = new contact_trace_Loader__c();
        Datetime dt1 = Datetime.now();
        Datetime dt2 = Datetime.now()+15;
        ctl.First_Exposure_Date__c = dt1;
        ctl.Last_Exposure_Date__c = dt2;
        ctl.IP_Tracer_Number__c = 'Tracer-0001';
        ctl.Manager_Email__c = 'test@gmail.com';
        ctl.Employee_Number__c = NEWUSER_EMP_ID;
        //AddHours
        ctl.Manager_Risk_Assessment_Request_Sent__c = DateTime.now().addHours(-24);
        //ctl.Manager_Risk_Assessment_Request_Sent__c = DateTime.now().addDays(-1);
        insert ctl;
        List<contact_trace_Loader__c> ctlList = new List<contact_trace_Loader__c>();
        ctlList.add(ctl);
        Test.startTest();
        COH_EmailEscalatetoManagerBatch obj = new COH_EmailEscalatetoManagerBatch();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        COH_EmailEscalatetoManagerForContactList coh = new COH_EmailEscalatetoManagerForContactList();
        coh.getContactList();
        COH_EmailEscalatetoManagerSchedule sh1 = new COH_EmailEscalatetoManagerSchedule();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1);
    }
}