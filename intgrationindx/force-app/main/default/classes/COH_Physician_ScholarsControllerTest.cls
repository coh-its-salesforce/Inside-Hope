/*
 * This test class verifies the functionality of the COH_Physician_ScholarsController class.  
 * 
 * Pavani Vunnam
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */

@isTest
public class COH_Physician_ScholarsControllerTest {
    
    // Test method to cover the COH_Physician_ScholarsController class.
    public testMethod static void unitTest() {
    
        // Insert Account   
        Account ac = new Account(name ='Grazitti') ;
        insert ac;
        
        // Insert Contact
        contact cont = new contact();
        cont.Lastname = 'TestL';
        cont.Email = 'xyz@coh.org';
        cont.International_Status__c = 'In Progress';
        cont.accountid =  ac.id;
        insert cont;
        
        // Insert Visa Information      
        visa__c Visa = new visa__c();
        Visa.Contact_Relationship__c = cont.id;
        insert Visa;

        // Insert Community_Notes_and_Attachment__c        
        Community_Notes_and_Attachment__c ComNoteAtt = new Community_Notes_and_Attachment__c();
        ComNoteAtt.Contact__c= cont.id;
        insert ComNoteAtt ;
        
        Community_Notes_and_Attachment__c  VisaNoteAtt = new Community_Notes_and_Attachment__c ();
        VisaNoteAtt.Visa__c = Visa.id;
        insert VisaNoteAtt ;
        
        
        // Insert Community User.       
        Map < String, Schema.SObjectType > completeobjMap = Schema.getGlobalDescribe();
        Schema.SObjectType selectedSobjType = completeobjMap.get('Contact');
        Schema.DescribeSObjectResult sObjResult = selectedSobjType.getDescribe();
        Map < String, Schema.RecordTypeInfo > RecordTypeInfo = sObjResult.getRecordTypeInfosByName();
        
        if (RecordTypeInfo.containsKey('Visiting Scholar Program ')) {
            cont.RecordTypeId = RecordTypeInfo.get('Visiting Scholar Program ').getRecordTypeId();
        }
        
        Id p = [select id from profile where name='Visiting Scholar Program'].id;
        UserLicense usr =[Select id from UserLicense where name='Customer Community Plus'];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = cont.Id, 
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;

        //  Instantiate the Attachment objects  
        Attachment att1 = new Attachment();
        Attachment att2 = new Attachment();
        Attachment att3 = new Attachment();
        Attachment att4 = new Attachment();
        Attachment att5 = new Attachment();
        Attachment att6 = new Attachment();
        Attachment att7 = new Attachment();
        Attachment att8 = new Attachment();
        Attachment att9 = new Attachment();
        Attachment att10 = new Attachment();
        Attachment att11 = new Attachment();
        Attachment att12 = new Attachment();
        Attachment att13 = new Attachment();
        Attachment att14 = new Attachment();
        Attachment att15 = new Attachment();
        Attachment att16 = new Attachment(); 
      
        //  Set the Attachments
        att1.Name = 'Test COH';
        att1.Body = Blob.valueOf('Test COH');
        att1.ParentId = ComNoteAtt.Id;
        //insert att1;
        
        att2.Name = 'Test COH';
        att2.Body = Blob.valueOf('Test COH');
        att2.ParentId = ComNoteAtt.Id;
        //insert att2;
        
        att3.Name = 'Test COH';
        att3.Body = Blob.valueOf('Test COH');
        att3.ParentId = ComNoteAtt.Id;
        //insert att3;
        
         att4.Name = 'Test COH';
        att4.Body = Blob.valueOf('Test COH');
        att4.ParentId = ComNoteAtt.Id;
        //insert att4;
        
         att5.Name = 'Test COH';
        att5.Body = Blob.valueOf('Test COH');
        att5.ParentId = ComNoteAtt.Id;
        //insert att5;
        
        att6.Name = 'Test COH';
        att6.Body = Blob.valueOf('Test COH');
        att6.ParentId = ComNoteAtt.Id;
        //insert att6;
        
        att7.Name = 'Test COH';
        att7.Body = Blob.valueOf('Test COH');
        att7.ParentId = ComNoteAtt.Id;
        //insert att7;
        
        att8.Name = 'Test COH';
        att8.Body = Blob.valueOf('Test COH');
        att8.ParentId = ComNoteAtt.Id;
        //insert att8;
        
        att9.Name = 'Test COH';
        att9.Body = Blob.valueOf('Test COH');
        att9.ParentId = ComNoteAtt.Id;
        //insert att9;
        
        att10.Name = 'Test COH';
        att10.Body = Blob.valueOf('Test COH');
        att10.ParentId = ComNoteAtt.Id;
        //insert att10;
        
        att16.Name = 'Test COH';
        att16.Body = Blob.valueOf('Test COH');
        att16.ParentId = ComNoteAtt.Id;
        //insert att16;
        
        att11.Name = 'Test COH';
        att11.Body = Blob.valueOf('Test COH');
        att11.ParentId = Visa.Id;
        //insert att11;
        
        att12.Name = 'Test COH';
        att12.Body = Blob.valueOf('Test COH');
        att12.ParentId = Visa.Id;
        //insert att12;
        
        att13.Name = 'Test COH';
        att13.Body = Blob.valueOf('Test COH');
        att13.ParentId = Visa.Id;
        //insert att13;
        
        att14.Name = 'Test COH';
        att14.Body = Blob.valueOf('Test COH');
        att14.ParentId = Visa.Id;
        //insert att14;
        
        att15.Name = 'Test COH';
        att15.Body = Blob.valueOf('Test COH');
        att15.ParentId = Visa.Id;
        //insert att15;
        
        //update user;
        //system.runAs(user){
        
        
        //  Start the Test Execution. 
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(cont);
        COH_Physician_ScholarsController Psc = new COH_Physician_ScholarsController(sc);
        Psc.attachment1 =   att1;
        Psc.attachment2 = att2;
        Psc.attachment3 = att3;
        Psc.attachment4 = att4;
        Psc.attachment5 = att5;
        Psc.attachment6 = att6;
        Psc.attachment7 = att7;
        Psc.attachment8 = att8;
        Psc.attachment9 = att9;
        Psc.attachment10 = att10;
        Psc.attachment11 = att11;
        Psc.attachment12 = att12;
        Psc.attachment13 = att13;
        Psc.attachment14 = att14;
        Psc.attachment15 = att15;
        Psc.attachment16 = att16;
        Psc.userDetails=user;
        PSc.con = cont;

        //Method Calls from the Class : OH_Physician_ScholarsController.
        Psc.upload();
        Psc.Approval();
        Psc.EditRedir();
        Test.stopTest();  // Stop the test execution
      //}
        
    }
}