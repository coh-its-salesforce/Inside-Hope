@isTest
private class COH_AllogeniecAndDeviationAttacUtil_Test {
    private static final String SECOND_ALOGENIC_MAIL_CONTENT = 'attachment' ;

   /* - Sanjay 11/15/2017
     * Test method to COHAttachmentUtility.processSecondAllogenicReqAttachmets
     * The test creates a Second Allogenic Record  record and adds an attachment to it.
     */
    private static testMethod void testSecondAllogenicRecordAttachments() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        test.startTest();
        
        Second_Allogeneic_Request__c req = new Second_Allogeneic_Request__c();
        req.Criteria_1__c = 'Remission post 1st HCT salvage therapy or sensitive disease';
        req.Remission_Post_Yes_No__c = 'Yes';
        req.Remission_Post_comment__c = 'Testing1';
        
        req.Criteria_2__c = 'Suitable donor available';
        req.Suitable_donor_available_Yes_No__c = 'Yes';
        req.Suitable_donor_available_comment__c = 'Testing2';
        req.Staff_name__c = userInfo.getUserId();
        req.Is_there_an_attachment__c = TRUE;
                
        req.Criteria_3__c = 'Adequate organ function';
        req.Adequate_organ_function_Yes_No__c = 'Yes';
        req.Adequate_organ_function_comment__c = 'Testing3';
        
        req.Criteria_4__c = 'KPS> 60% or ECOG>2';
        req.KPS_60_or_ECOG_2_Yes_No__c = 'Yes';
        req.KPS_60_or_ECOG_2_comment__c = 'Tesing4';
        
        req.Criteria_5__c = 'No active infection';
        req.No_active_infection_Yes_No__c = 'Yes';
        req.No_active_infection_comment__c = 'Testing5';
                
        req.Criteria_6__c = 'Approved by ID (if recent fungal ID)';
        req.Approved_by_ID_Yes_No__c = 'Yes';
        req.Approved_by_ID_comment__c = 'Testing6';
                
        req.Criteria_7__c = '> 6 months since 1st HCT';
        req.X6month_since_1st_HCT_Yes_No__c = 'Yes';
        req.X6month_since_1st_HCT_comment__c = 'Testing7';
        
        req.Criteria_8__c = 'Insurance authorized 2nd HCT';
        req.Insurance_authorized_2nd_HCT_Yes_No__c = 'Yes';
        req.Insurance_authorized_2nd_HCT_comment__c = 'Testing8';        
        
        req.Criteria_9__c = 'Leukemia pt.: BMBX within 2 weeks of 2nd HCT';
        req.BMBX_within_2weeks_of_2nd_HCT_Yes_No__c = 'Yes';
        req.BMBX_within_2weeks_of_2nd_HCT_comment__c = 'Testing9';
        
        req.Criteria_10__c = 'Leukemia pt: BMBX <30% blast and no PB blast';
        req.BMBX_30_blast_and_no_PB_blast_Yes_No__c = 'Yes';
        req.BMBX_30_blast_and_no_PB_blast_comment__c = 'Testing10';        
        
        req.Gender__c = 'Male';
        req.Reviewer_Summary__c = 'Test Review';
        req.Age__c = 25;
        req.Email_Sent__c = false;
        
        insert req;

        
        Attachment attachmentObj = createAttachmentObject(req.Id, SECOND_ALOGENIC_MAIL_CONTENT);
        database.insert(attachmentObj, false);
        test.stopTest();
    }
       
    
    /* -  - Sanjay  01/30/2018
     * Test method to COHAttachmentUtility.processSecondAllogenicReqAttachmets
     * The test creates a Second Allogenic Record  record and adds a Content to it.
     */
    private static testMethod void testSecondAllogenicRecordContent() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        test.startTest();
        
        Second_Allogeneic_Request__c req = new Second_Allogeneic_Request__c();
        req.Criteria_1__c = 'Remission post 1st HCT salvage therapy or sensitive disease';
        req.Remission_Post_Yes_No__c = 'Yes';
        req.Remission_Post_comment__c = 'Testing1';
        
        req.Criteria_2__c = 'Suitable donor available';
        req.Suitable_donor_available_Yes_No__c = 'Yes';
        req.Suitable_donor_available_comment__c = 'Testing2';
        req.Staff_name__c = userInfo.getUserId();
        req.Is_there_an_attachment__c = TRUE;
                
        req.Criteria_3__c = 'Adequate organ function';
        req.Adequate_organ_function_Yes_No__c = 'Yes';
        req.Adequate_organ_function_comment__c = 'Testing3';
        
        req.Criteria_4__c = 'KPS> 60% or ECOG>2';
        req.KPS_60_or_ECOG_2_Yes_No__c = 'Yes';
        req.KPS_60_or_ECOG_2_comment__c = 'Tesing4';
        
        req.Criteria_5__c = 'No active infection';
        req.No_active_infection_Yes_No__c = 'Yes';
        req.No_active_infection_comment__c = 'Testing5';
                
        req.Criteria_6__c = 'Approved by ID (if recent fungal ID)';
        req.Approved_by_ID_Yes_No__c = 'Yes';
        req.Approved_by_ID_comment__c = 'Testing6';
                
        req.Criteria_7__c = '> 6 months since 1st HCT';
        req.X6month_since_1st_HCT_Yes_No__c = 'Yes';
        req.X6month_since_1st_HCT_comment__c = 'Testing7';
        
        req.Criteria_8__c = 'Insurance authorized 2nd HCT';
        req.Insurance_authorized_2nd_HCT_Yes_No__c = 'Yes';
        req.Insurance_authorized_2nd_HCT_comment__c = 'Testing8';        
        
        req.Criteria_9__c = 'Leukemia pt.: BMBX within 2 weeks of 2nd HCT';
        req.BMBX_within_2weeks_of_2nd_HCT_Yes_No__c = 'Yes';
        req.BMBX_within_2weeks_of_2nd_HCT_comment__c = 'Testing9';
        
        req.Criteria_10__c = 'Leukemia pt: BMBX <30% blast and no PB blast';
        req.BMBX_30_blast_and_no_PB_blast_Yes_No__c = 'Yes';
        req.BMBX_30_blast_and_no_PB_blast_comment__c = 'Testing10';        
        
        req.Gender__c = 'Male';
        req.Reviewer_Summary__c = 'Test Review';
        req.Age__c = 25;
        req.Email_Sent__c = false;
        
        insert req;

        createContent(req.Id, SECOND_ALOGENIC_MAIL_CONTENT);
        
        test.stopTest();
    }   
    
    /* - Sanjay 09/02/2017
     * Test method to COHAttachmentUtility.processDeviationAttachments
     * The test creates a deviation Record  record and adds an attachment to it.
     */
    private static testMethod void testDeviationRecordAttachments() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        test.startTest();
        Deviations__c dev = new Deviations__c();
        dev.Email_Sent__c = false;
        dev.Is_there_an_attachment__c = TRUE;
        DEV.Staff_Name__c = userInfo.getUserId();
        DEV.CC1__c = userInfo.getUserId();
        DEV.CC2__c = userInfo.getUserId();
        DEV.CC3__c = userInfo.getUserId();
        DEV.CC4__c = userInfo.getUserId();
        DEV.CC5__c = userInfo.getUserId();
        Account acc = new Account(name='TestAcc');
        insert acc;
        dev.Patient_Donor_Name__c = acc.Id;
        dev.Type__c  = 'Allo-Sibling';
        dev.Regimen__c = 'test';
        dev.Source__c = 'Cord Blood';
        dev.Description_of_deviation__c = 'test';
        dev.Proposed_plan_of_care__c = 'Test';
        
        contact cn = new Contact(FirstName = 'Test', LastName='Con', Email = 'a@b.c');
        insert cn;
        //dev.MD_Requesting__c = cn.Id;
        dev.Requesting_MD__c = userinfo.getuserid();
        database.insert(dev);
        system.debug('========'+[Select id, Name, Email_Sent__c from  Deviations__c where id=: dev.id]);
        Attachment attachmentObj = createAttachmentObject(dev.Id, 'DevAttachment');
        
        database.insert(attachmentObj, false);
        test.stopTest();
    }   
    
    
    /* -  - Sanjay  01/30/2018
     * Test method to COHAttachmentUtility.processDeviationAttachments
     * The test creates a deviation Record  record and adds a content to it.
     */
    private static testMethod void testDeviationRecordContent() {
        TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        Test.setMock(HttpCalloutMock.class,instance);
        test.startTest();
        Deviations__c dev = new Deviations__c();
        dev.Email_Sent__c = false;
        dev.Is_there_an_attachment__c = TRUE;
        DEV.Staff_Name__c = userInfo.getUserId();
        DEV.CC1__c = userInfo.getUserId();
        DEV.CC2__c = userInfo.getUserId();
        DEV.CC3__c = userInfo.getUserId();
        DEV.CC4__c = userInfo.getUserId();
        DEV.CC5__c = userInfo.getUserId();
        Account acc = new Account(name='TestAcc');
        insert acc;
        dev.Patient_Donor_Name__c = acc.Id;
        dev.Type__c  = 'Allo-Sibling';
        dev.Regimen__c = 'test';
        dev.Source__c = 'Cord Blood';
        dev.Description_of_deviation__c = 'test';
        dev.Proposed_plan_of_care__c = 'Test';
        
        contact cn = new Contact(FirstName = 'Test', LastName='Con', Email = 'a@b.c');
        insert cn;
        dev.MD_Requesting__c = cn.Id;
        database.insert(dev);
        system.debug('========'+[Select id, Name, Email_Sent__c from  Deviations__c where id=: dev.id]);
        createContent(dev.Id, 'Deviation');
        test.stopTest();
    }   
    
    /*
     * Create an Attachment object and assign it the ID of the parent Case object.
     * 
     * @param   parentObjectID  ID of the parent object.
     * @param   attachmentName  Name of the attachment.
     * @return                  Attachment object
     * 
     */
    private static Attachment createAttachmentObject(Id parentObjectID, String attachmentName) {
        Attachment attachmentObj = new Attachment();
        attachmentObj.Body = Blob.valueOf('Now I know what you\'re thinking...');
        attachmentObj.Name = attachmentName;
        attachmentObj.ParentId = parentObjectID;   
        return attachmentObj;
    }
    /* - Pavani  09/06/2018
     * Create an contentVersion object and assign it the ID of the parent visa object.
     */
    
    private static testmethod void testEmailNot(){
visa__c Visa = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Case_Type__c= 'Transfer from another Organization',Community_User_Name__c =userinfo.getuserid());
        insert Visa;
Attachment attachment = new Attachment();
       attachment.Body = Blob.valueOf('abcd');
       attachment.Name = String.valueOf('test.txt');
       attachment.ParentId = Visa.Id;
       insert attachment;

}

    
    
    /* - Sanjay  01/30/2018
     * Create an contentVersion object and assign it the ID of the parent Case object.
     * 
     * @param   parentObjectID  ID of the parent object.
     * @param   attachmentName  title of the contetn.
     * @return                  NA
     * 
     */
    private static void createContent(Id parentObjectID, String attachmentName) {
        
        ContentVersion contentVersion = new ContentVersion(
          Title = attachmentName,
          PathOnClient = attachmentName+'.txt',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = parentObjectID;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        database.insert(cdl, false);
    }

}