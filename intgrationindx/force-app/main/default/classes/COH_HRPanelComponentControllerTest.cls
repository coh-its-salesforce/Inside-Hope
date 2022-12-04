@isTest
public class COH_HRPanelComponentControllerTest {
    @isTest
    static void myUnitTest(){
        HR_Portal_Panel_Link__c link = new HR_Portal_Panel_Link__c();
        link.Panel_Name__c = 'TEST';
        link.Link_Label__c = 'label';
        link.Link_URL__c = 'http://test.test';
        link.Order__c = 1;
        link.Display__c = true;
        insert link;
        test.startTest();
        COH_HRPanelComponentController c = new COH_HRPanelComponentController();
        c.panelNamestr = 'TEST';
        List<HR_Portal_Panel_Link__c> records = c.getLinkList();
        test.stopTest();
        List<HR_Portal_Panel_Link__c> links = COH_HRPanelComponentController.getpanelLinkList('TEST');
        system.assert(records.size() == 1);
    }
}