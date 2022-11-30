@isTest(SeeAllData=true)
private class COH_SIRP_myNewsCompController_Test {
    private static testMethod void myNewsCompUnitTest(){
        My_News__c Ns1 = new My_News__c();
        Ns1.Name = 'Test1';
        Ns1.Show_On_Home__c = true;
        Ns1.URL__c = 'www.test.com';
        Ns1.User1__c = UserInfo.getUserId();
        insert Ns1;
        
       COH_SIRP_myNewsCompController Nsc = new COH_SIRP_myNewsCompController();
        Nsc.doEdit();
        Nsc.linkorder = 0;
        Nsc.getMyNewsLinks();

        Nsc.doSave();
        Nsc.addNew();
        Nsc.doSave();
        Nsc.linkorder = 0;
        Nsc.removeLink();
        Nsc.doCancel();
            
    }
}