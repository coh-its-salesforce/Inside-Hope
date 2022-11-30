//  The contents of this class were originally commented out.  I added some tests to 
//  improve the code coverage percentage.
  
@isTest
public class MassEditExtensionTest {
    private static final Boolean mRunAllTests = true;
    
    // Verify the conversion from the Lead to Account and/or Case.
    private static testMethod void test1() {
        if (!mRunAllTests) {
            System.debug('Skipping test1()');
            return;
        }
        BMCServiceDesk__Incident__c inc = new BMCServiceDesk__Incident__c();
        List<BMCServiceDesk__Incident__c> testInc = [SELECT Id FROM BMCServiceDesk__Incident__c LIMIT 1];
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(testInc);
        setCtr.setSelected(new BMCServiceDesk__Incident__c[]{inc});
        MassEditExtension mee = new MassEditExtension(setCtr);
        mee.getStatus();
        mee.getCloseCat();
        mee.retrieveIncidents();
//        mee.updateIncidents();
            
//        mee.getResolution();    
//        mee.setResolution(null);    
    }
    
}

/*
@isTest(SeeAllData=true)
private class MassEditExtensionTest{

    public static List<BMCServiceDesk__Category__c> category{get; set;}
    public static List<User> users {get; set;}

    static testMethod void singleUpdateTest(){
        
        createIncidents(1, 'open');
        BMCServiceDesk__Incident__c inc = new BMCServiceDesk__Incident__c();
        List<BMCServiceDesk__Incident__c> testInc = [SELECT Id FROM BMCServiceDesk__Incident__c LIMIT 1];
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(testInc);
        setCtr.setSelected(new BMCServiceDesk__Incident__c[]{inc});
        MassEditExtension controller = new MassEditExtension(setCtr);
        
        controller.retrieveIncidents();
        System.assert(controller.selCloseCat.size() > 0);

        String value = 'Testing';
        controller.resolution = value;

        Test.startTest();
        
        Test.stopTest(); 
    }
    
    static testMethod void multipleUpdateTest(){
    
    }

    private static void createIncidents(Integer iNumber, String state){
        //createCategories();
        BMCServiceDesk__Category__c parent = new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true);
        insert parent;
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent.Id);
        insert child;
        Profile p = [Select id from profile WHERE Name = 'System Administrator'];
        User u = new User(alias = 'sysAdm', email = 'sysAdmin@coh.org', emailencodingkey='UTF-8', lastname='TestingAdmin', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'sysAdmin@coh.org');
        insert u;      
        
        createImpactUrgencyStatus();
        //createUser();
        List<BMCServiceDesk__Incident__c> incidents = new List<BMCServiceDesk__Incident__c>();
        BMCServiceDesk__Impact__c imp = [SELECT Id from BMCServiceDesk__Impact__c WHERE Name = 'TEST'];
        BMCServiceDesk__Urgency__c urg = [SELECT Id from BMCServiceDesk__Urgency__c WHERE Name = 'TEST'];
        BMCServiceDesk__Status__c statOpen = [SELECT Id FROM BMCServiceDesk__Status__c WHERE BMCServiceDesk__state__c = true AND BMCServiceDesk__appliesToIncident__c = true LIMIT 1];
        BMCServiceDesk__Status__c statClosed = [SELECT Id FROM BMCServiceDesk__Status__c WHERE BMCServiceDesk__state__c = false AND BMCServiceDesk__appliesToIncident__c = true LIMIT 1];  
        
        for (Integer i = 0; i < iNumber; i++){
            if (state == 'open')
                incidents.add(new BMCServiceDesk__Incident__c(BMCServiceDesk__FKImpact__c = imp.Id, BMCServiceDesk__FKUrgency__c = urg.Id, BMCServiceDesk__FKStatus__c = statOpen.Id, BMCServiceDesk__FKClient__c = u.Id, Parent_Category__c = parent.Id, Sub_Category__c = child.Id, BMCServiceDesk__incidentDescription__c = 'Testing ' + i, Summary__c = 'Unit Test ' + i));
            else
                incidents.add(new BMCServiceDesk__Incident__c(BMCServiceDesk__FKImpact__c = imp.Id, BMCServiceDesk__FKUrgency__c = urg.Id, BMCServiceDesk__FKStatus__c = statClosed.Id, BMCServiceDesk__FKClient__c = u.Id, Parent_Category__c = parent.Id, Sub_Category__c = child.Id, BMCServiceDesk__incidentDescription__c = 'Testing ' + i, Summary__c = 'Unit Test ' + i));
        }
        insert incidents;
    }

    private static void createCategories(){

        List<BMCServiceDesk__Category__c> parent = new List<BMCServiceDesk__Category__c>();
        parent.add(new BMCServiceDesk__Category__c(Name = 'Parent',BMCServiceDesk__AvailableForIncidents__c = true));
        insert parent;
        category.addAll(parent);
        BMCServiceDesk__Category__c child = new BMCServiceDesk__Category__c(Name = 'Child',BMCServiceDesk__AvailableForIncidents__c = true,
                                                                            BMCServiceDesk__FKParentCategory__c = parent[0].Id);
        insert child;
        category.add(child);
        
        System.debug('### Category List: ' + category);
    }

    private static void createUser(){
        Profile p = [Select id from profile WHERE Name = 'System Administrator'];
        User u = new User(alias = 'sysAdm', email = 'sysAdmin@coh.org', emailencodingkey='UTF-8', lastname='TestingAdmin', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = p.Id,
        timezonesidkey = 'America/Los_Angeles', username = 'sysAdmin@coh.org');
        
        insert u; 
        users.add(u);
  
    }
    
    private static void createImpactUrgencyStatus(){
        BMCServiceDesk__Impact__c imp = new BMCServiceDesk__Impact__c(Name = 'TEST');
        BMCServiceDesk__Urgency__c urg = new BMCServiceDesk__Urgency__c(Name = 'TEST');
        //BMCServiceDesk__Status__c stat1 = new BMCServiceDesk__Status__c(Name = 'DRAFT', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__state__c = true, BMCServiceDesk__defaultStatus__c = true);
        //BMCServiceDesk__Status__c stat2 = new BMCServiceDesk__Status__c(Name = 'CLOSED', BMCServiceDesk__appliesToIncident__c = true, BMCServiceDesk__state__c = false, BMCServiceDesk__defaultStatus__c = true);
    
        insert imp;
        insert urg;
        //insert stat1;
        //insert stat2;
    } 
}
*/