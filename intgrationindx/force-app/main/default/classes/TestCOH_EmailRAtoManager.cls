@isTest
public class TestCOH_EmailRAtoManager {
    static TestMethod void validateTheSendEmails(){
         String NEWUSER_EMP_ID = '101010';
        contact_trace_Loader__c ctl = new contact_trace_Loader__c();
        Datetime dt1 = Datetime.now();
        Datetime dt2 = Datetime.now()+15;
		ctl.First_Exposure_Date__c = dt1;
        ctl.Last_Exposure_Date__c = dt2;
        ctl.IP_Tracer_Number__c = 'Tracer-0001';
        ctl.Manager_Email__c = 'test@gmail.com';
        ctl.Employee_Number__c = NEWUSER_EMP_ID;
        insert ctl;
        List<Id> ctlList = new List<Id>();
        ctlList.add(ctl.Id);
        COH_EmailRAtoManager ETM = new COH_EmailRAtoManager();
        COH_EmailRAtoManager.sendEmailtoManager(ctlList);
        COH_EmailRAtoManager.selectedIds=ctlList;
        ETM.conManagerEmail='test@gmail.com';
        ETM.getContactList();
    }
}