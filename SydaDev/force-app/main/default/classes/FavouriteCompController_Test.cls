@isTest(SeeAllData=true)
private class FavouriteCompController_Test {
    private static testMethod void myfavcomUnitTest(){
        Master_Favorite_Link__c fv2 = new Master_Favorite_Link__c();
        //fv2.Name = 'Test2';
        fv2.URL__c = 'Test3';
        fv2.Link__c = 'www.test1.com';
        //fv2.User__c = UserInfo.getUserId();
        insert fv2;
        
        My_Favourite__c fv1 = new My_Favourite__c();
        fv1.Name = 'Test1';
        fv1.Show_On_Home__c = true;
        fv1.URL__c = 'www.test.com';
        fv1.User__c = UserInfo.getUserId();
        fv1.Master_Favorite_Link__c = fv2.id;
        insert fv1;
        
        FavouriteCompController fvc = new FavouriteCompController();
        fvc.doEdit();
        fvc.linkorder = 0;
        fvc.getMyFavlinks();
        fvc.getAllFevouriteLinsList();
        fvc.OnchangeLink();
        fvc.myFavList[0].SelectedValue = 'SELECT1';
        fvc.doSave();
        fvc.myFavList[0].SelectedValue = 'Test1 : www.test.com';
        fvc.doSave();
        fvc.addNew();
        fvc.doSave();
        fvc.linkorder = 0;
        fvc.removeLink();
        fvc.doCancel();
            
    }
}