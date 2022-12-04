@isTest
public class immigrationServicesCtlTest{
    public testMethod static void unitTest() {
    
        Account ac = new Account(name ='Grazitti') ;
        insert ac;
        
        contact cont = new contact();
        cont.Lastname = 'TestL';
        cont.Email = 'xyz@coh.org';
        //cont.Status__c = 'In Progress';
        cont.accountid =  ac.id;
        insert cont;
        test.starttest();
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Profile p = [select Id,name from Profile where Name=:'International Services' limit 1];
        
        User portaluser = new User(UserRoleId = ur.Id,profileId = p.id, 
                username = 'newUser@yahoo.com', 
                email = 'pb@ff.com', 
                emailencodingkey = 'UTF-8', 
                localesidkey = 'en_US', 
                languagelocalekey = 'en_US', 
                timezonesidkey = 'America/Los_Angeles', 
                alias='nuser', 
                lastname='lastname', 
                contactId = cont.id);
        //insert portaluser;
        test.stoptest();
        List<RequiredDocuments__c> rdList = new List<RequiredDocuments__c>();
        RequiredDocuments__c rd = new RequiredDocuments__c(Name='1',Document__c='Copy of Passport',Status__c='new;ext;Transfer',Type__c='J-1');
        RequiredDocuments__c rd1 = new RequiredDocuments__c(Name='2',Document__c='Copy of Passport',Status__c='new;ext;Transfer',Type__c='F-1');
        RequiredDocuments__c rd2 = new RequiredDocuments__c(Name='3',Document__c='Copy of Passport',Status__c='new;ext;Transfer',Type__c='STEM/OPT');
        rdList.add(rd);rdList.add(rd1);rdList.add(rd2);
        insert rdList;
        visa__c Visa = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Number_of_Dependencies__c = '1', Case_Type__c= 'Transfer from another Organization',Community_User_Name__c =userinfo.getuserid());
        insert Visa;
        
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('abcd');
        attachment.Name = String.valueOf('test.txt');
        attachment.ParentId = Visa.Id;
        insert attachment;

        //system.runAs(portaluser){
        
            ApexPages.StandardController std = new ApexPages.StandardController(Visa);
            immigrationServicesCtl img = new immigrationServicesCtl(std);
            img.EditRec();
            img.saveRecord();
            img.submitForApproval();
            img.J1List[0].att.Name = 'testJ1.doc';
            img.J1List[0].att.body = Blob.valueOf('testJ1');
            img.selectedDoc = 'J-1';
            img.uploadDocument();
            img.F1List[0].att.Name = 'testF1.doc';
            img.F1List[0].att.body = Blob.valueOf('testF1');
            img.selectedDoc = 'F-1';
            img.uploadDocument();
            img.STEMList[0].att.Name = 'testStem.doc';
            img.STEMList[0].att.body = Blob.valueOf('testStem');
            img.selectedDoc = 'STEM/OPT';
            img.uploadDocument();
            
       // }

        
    }
}