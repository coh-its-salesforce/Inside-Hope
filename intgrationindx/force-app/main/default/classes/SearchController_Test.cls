@isTest
private class SearchController_Test {
    private static testmethod void myUnitTestOne(){
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        contact con = new Contact();
        con.FirstName= 'Test';
        con.LastName ='ss';
        con.Email = 'a@b.c';
        insert con;
        Search_Object__c so = new Search_Object__c();
        so.Name = 'Account';
        so.Object_API_Name__c = 'Account';
        insert so;
        
        Filter_Field__c ff = new Filter_Field__c();
        ff.Search_object__c = so.id;
        ff.Name = 'Name';
        ff.Order__c = 0;
        ff.Field_API_Name__c = 'Name';
        insert ff;
        
        Search_Field__c sf = new Search_Field__c();
        sf.Search_object__c = so.id;
        sf.Name = 'Name';
        sf.Order__c = 0;
        sf.Field_API_Name__c = 'Name';
        insert sf;
        Document document = new Document();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        document.body = blob.valueOf('TEST');
        document.Name = 'Test.txt';
        insert document;
        
        apexpages.currentPage().getParameters().put('keyword','test');
        SearchController sc = new SearchController();
        string rtypeStr = sc.contentTypeList[0].recTypeId;
        
        sc.getAllFilters();
        for(SearchController.fieldWrapper fw: sc.filterList){
            fw.obj.put(fw.field.Field_API_Name__c, 'Test');
        }
        sc.createFilterStr();
        SearchController.searchKeyWord('test','Account:Name:Test','','','', 
                                       false, false, false, false, false,false, false,false);
        SearchController.searchKeyWord('test','Account:Name:Test',rtypeStr,'','Medical Center', 
                                       true, true, true, true, true,true, true,true);
        
    }
    
    /* Test Method */
    
    private static testMethod void myUnitTestTwo(){
        SearchObjectSettingController sosc = new SearchObjectSettingController();
        sosc.getObjectNames();
        sosc.doSave();
        sosc.selectedObject = 'Account';
        sosc.populateFields();
        sosc.selectedFields = new List<selectoption>();
        sosc.selectedFields.add(new SelectOption('Name', 'Name'));
        sosc.selectedFilterField = new List<selectoption>();
        sosc.selectedFilterField.add(new SelectOption('Name', 'Name'));
        sosc.doSave();
        sosc.selectedObject = 'Account';
        sosc.populateFields();
        
        sosc.findObjectFields();
        sosc.editForRearrange();
        sosc.OptionsHidden = sosc.searchObj.id;
        sosc.fetchSearchObject();
        sosc.reArrangeOrder();
        sosc.doSave();
    }
    
    private static testmethod void myUnitTestContentDocLinkTrig(){
        
        ContentVersion contentVersion = new ContentVersion(
         Title = 'Test',
          PathOnClient = 'Test.txt',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        contact cn = new Contact(FirstName = 'Test', LastName='Con', Email = 'a@b.c');
        insert cn;
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = cn.ID;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        system.assertEquals(true, [Select id ,  Do_not_Include_in_Search__c from ContentVersion Where id=:contentVersion.ID].Do_not_Include_in_Search__c);
    }
    
    
    
}