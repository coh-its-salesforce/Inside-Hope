@isTest
public class ITSProjectApprovalControllerTest {
    static testmethod void myUnitTest(){
        
        
        ITS_Project_Request__c its = new ITS_Project_Request__c();
        its.Name = 'Test Project';
        insert its;   
        
        List<ITS_Project_Request__c> itsList = new List<ITS_Project_Request__c>();
        itsList.add(its);
        ApexPages.StandardController controller = new ApexPages.StandardController(its);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(new ITS_Project_Request__c());
        ApexPages.StandardSetController listcontroller = new ApexPages.StandardSetController(itsList);
        ITSProjectApprovalController ipc= new ITSProjectApprovalController(controller);
        
        listcontroller.setSelected(itsList); 
        ITSProjectApprovalController ipc1= new ITSProjectApprovalController(listcontroller);
        ITSProjectApprovalController ipc2= new ITSProjectApprovalController(controller1);
        ipc.doSingleSave();
        ipc.acc.commented__c = 'This is test';
        ipc1.DoSave();
        for(ITS_Project_Request__c ip:ipc1.selectedProject ){
            ip.commented__c = 'This is test comment.';
        }    
        ipc1.DoSave();
        ipc.doSingleSave();
        ipc2.doSingleSave();
        
        system.assertEquals('Need More Details', [Select Approve_Status__c from ITS_Project_Request__c where id =:its.id ][0].Approve_Status__c);
    }
}