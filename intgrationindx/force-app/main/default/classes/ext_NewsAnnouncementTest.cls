@isTest
public class ext_NewsAnnouncementTest {
	public testMethod static void ext_NewsAnnouncementTest(){
        Department__c dept = new Department__c();
        dept.Name = 'Test Department';
        insert dept;
        
        COH_SI_NewsandAnnouncement__c coh = new COH_SI_NewsandAnnouncement__c();
        coh.Description__c = 'Testing description for test class';
        coh.Title__c = 'Testing title for test class';
        coh.Department__c = dept.Id;
        coh.Org_Wide__c = true;
		coh.Display__c = true;
        coh.Start_Date_Time__c = System.now();
        coh.Stop_Date_Time__c = System.now();
        insert coh;
        
        Attachment att = new Attachment();
        att.Name = 'Test COH';
        att.Body = Blob.valueOf('Test COH');
        att.ParentId = coh.Id;
        insert att;
        
        ext_NewsAnnouncement ex = new ext_NewsAnnouncement();
    }
}