@isTest
public with sharing class tst_ganttChartRM {
    private static string Role = 'QA/Tester'; 
    private static string Roles = 'QA/Tester';
    @isTest
        static void ganttChart_getChartData() {

            Date d = Date.today();
            DateTime dt = DateTime.now();
            //create test user

            User recEmployee = tst_ganttChartRM.getRecUser();
            Id recMgrId = recEmployee.Mgr__c;
            User recMgr = [select Id from User where Id =: recMgrId];
            Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
            System.runAs(recMgr){
                IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                    Name='Test Project',
                    Color__c='Orange',
                    Status__c ='Active',
                    Project_Schedule__c  = 'Green',
                    Scope__c = 'Green',
                    Project_Financial__c  = 'Green',
                    Project_Resources__c = 'Green',
                    Project_Status__c = 'In-Progress',
                    RecordTypeId = LifeCycleRecTypeId);
                insert p;
            
            IT_Resource__c r = new IT_Resource__c(
                Name='Test Resource',
                Roles__c =Roles,
                Role__c = Role,
                Employee__c = recEmployee.Id);
            
            insert r;
            
            Team_Assignment__c a = new Team_Assignment__c(
                Life_Cycle__c  = p.Id,
                IT_Resource__c  = r.Id,
                Start_Date__c = d,
                End_Date__c = d,
                Role__c = Role,
                Number_of_Hours__c = 40);
            insert a;
            
            Test.startTest();
            Map<String, Object> chartData = ganttChartRM.getChartData(
                null,
                String.valueOf(dt.getTime()),
                String.valueOf(dt.getTime()),
                1,
                new List<String>(),
                new List<String>(),
                '');
            Test.stopTest();
            
            System.assert(chartData.containsKey('projects'));
            List<Object> projects = (List<Object>)chartData.get('projects');
            System.assertEquals(1, projects.size());
            Map<String, Object> projectMap = (Map<String, Object>)projects.get(0);
            System.assertEquals(p.Id, (String)projectMap.get('Id'));
            
            System.assert(chartData.containsKey('resources'));
            List<Object> resources = (List<Object>)chartData.get('resources');
            System.assertEquals(1, resources.size());
            Map<String, Object> resourceMap = (Map<String, Object>)resources.get(0);
            System.assertEquals(r.Id, (String)resourceMap.get('Id'));
            
            System.assert(chartData.containsKey('roles'));
            Set<String> roles = (Set<String>)chartData.get('roles');
            System.assertEquals(1, roles.size());
            System.assert(roles.contains(r.Roles__c));
            }
        }

    
    @isTest
    public Static User getRecManager(){
        Profile recProfile = [select Id from Profile Where Name = 'ServiceDesk Client' Limit 1];
        User mgrU = new User();
        mgrU.isactive = true;
        mgrU.FirstName = 'MGRTestFirstName';
        mgrU.LastName = 'TestLastName';
        mgrU.EmployeeNumber = 'MGRTest';
        mgrU.Email = 'MGRtestUser@coh.org';
        mgrU.alias = 'MGRUser';
        mgrU.CommunityNickname ='MGRtestUser@coh.org';
        mgrU.EmailEncodingKey =  'ISO-8859-1';
        mgrU.LanguageLocaleKey = 'en_US';
        mgrU.LocaleSidKey = 'en_US';
        mgrU.ProfileId = recProfile.Id;
        mgrU.TimeZoneSidKey = 'America/Los_Angeles';
        mgrU.Username = 'MGRtestUser@coh.org';
        insert mgrU;
        return mgrU;
    }
    
    public Static User getRecUser() {
        User mgrU = tst_ganttChartRM.getRecManager();
        Profile recProfile = [select Id from Profile Where Name = 'ServiceDesk Client' Limit 1];
        User u = new User();
        u.isactive = true;
        u.FirstName = 'TestFirstName';
        u.LastName = 'TestLastName';
        u.EmployeeNumber = 'gNumber';
        u.Email = 'GantttestUser@coh.org';
        u.alias = 'testUser';
        u.CommunityNickname ='GantttestUser@coh.org';
        u.EmailEncodingKey =  'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = recProfile.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.Username = 'GantttestUser@coh.org';
        u.mgr__c = mgrU.Id;
        insert u;
        return u;
    }

    @isTest
    static void ganttChart_getChartData_withFilters() {
        Date d = Date.today();
        DateTime dt = DateTime.now();
        User recEmployee = tst_ganttChartRM.getRecUser();
        Id recMgrId = recEmployee.Mgr__c;
        User recMgr = [select Id from User where Id =: recMgrId];
        Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        System.runAs(recMgr){
            IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                Name='Test Project',
                Color__c='Orange',
                Status__c ='Active',
                Project_Schedule__c  = 'Green',
                Scope__c = 'Green',
                Project_Financial__c  = 'Green',
                Project_Resources__c = 'Green',
                Project_Status__c = 'In-Progress',
                RecordTypeId = LifeCycleRecTypeId);
            insert p;
            
            IT_Resource__c r = new IT_Resource__c(
                Name='Test Resource',
                Roles__c =Roles,
                Role__c = Role,
                Employee__c = recEmployee.Id);
            
            insert r;
            
            Team_Assignment__c a = new Team_Assignment__c(
                Life_Cycle__c  = p.Id,
                IT_Resource__c  = r.Id,
                Start_Date__c = d,
                End_Date__c = d,
                Role__c = Role,
                Number_of_Hours__c = 40);
            insert a;
/*                
                Project__c p = new Project__c(
                    Name='Test Project',
                    Color__c='Orange');
                insert p;
                
                Resource__c r = new Resource__c(
                    Name='Test Resource',
                    Default_Role__c='Test Role');
                insert r;
                
                Allocation__c a = new Allocation__c(
                    Project__c = p.Id,
                    Resource__c = r.Id,
                    Effort__c = 'High',
                    Status__c = 'Active',
                    Start_Date__c = d,
                    End_Date__c = d);
                insert a;
*/
    
                Test.startTest();
                Map<String, Object> chartData = ganttChartRM.getChartData(
                    r.Id,
                    String.valueOf(dt.getTime()),
                    String.valueOf(dt.getTime()),
                    1,
                    new List<String> { p.Id },
                    new List<String> { r.Role__c },
                    a.Status__c);
                Test.stopTest();
                
                System.assert(chartData.containsKey('projects'));
                List<Object> projects = (List<Object>)chartData.get('projects');
                System.assertEquals(1, projects.size());
                Map<String, Object> projectMap = (Map<String, Object>)projects.get(0);
                System.assertEquals(p.Id, (String)projectMap.get('Id'));
                
                System.assert(chartData.containsKey('resources'));
                List<Object> resources = (List<Object>)chartData.get('resources');
                System.assertEquals(1, resources.size());
                Map<String, Object> resourceMap = (Map<String, Object>)resources.get(0);
                System.assertEquals(r.Id, (String)resourceMap.get('Id'));
                
                System.assert(chartData.containsKey('roles'));
                Set<String> roles = (Set<String>)chartData.get('roles');
                System.assertEquals(1, roles.size());
                System.assert(roles.contains(r.Role__c));
        }
    }

    @isTest
    static void ganttChart_getResources() {
        User recEmployee = tst_ganttChartRM.getRecUser();
        Id recMgrId = recEmployee.Mgr__c;
        User recMgr = [select Id from User where Id =: recMgrId];
        System.runAs(recMgr){
        IT_Resource__c r = new IT_Resource__c(
            Name='Test Resource',
            Roles__c =Roles,
            Role__c = Role,
            Employee__c = recEmployee.Id);
        insert r;

        Test.startTest();
        List<Object> resources = ganttChartRM.getResources();
        Test.stopTest();

        System.assertEquals(1, resources.size());
        System.assertEquals(r.Id, ((Map<String, Object>)resources.get(0)).get('Id'));
        System.assertEquals(r.Role__c, ((Map<String, Object>)resources.get(0)).get('Default_Role__c'));
        }
    }

    @isTest
    static void ganttChart_getProjects() {
        Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();            
            IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                Name='Test Project',
                Color__c='Orange',
                Status__c ='Active',
                Project_Schedule__c  = 'Green',
                Scope__c = 'Green',
                Project_Financial__c  = 'Green',
                Project_Resources__c = 'Green',
                Project_Status__c = 'In-Progress',
                RecordTypeId = LifeCycleRecTypeId);
            insert p;

        Test.startTest();
        List<IT_Portfolio_Management__c> projects = ganttChartRM.getProjects();
        Test.stopTest();

        System.assertEquals(1, projects.size());
        System.assertEquals(p.Id, projects.get(0).Id);
    }
    
    @isTest
    static void ganttChart_saveAllocation() {
        Date d = Date.today();
        DateTime dt = DateTime.now();

        User recEmployee = tst_ganttChartRM.getRecUser();
        Id recMgrId = recEmployee.Mgr__c;
        User recMgr = [select Id from User where Id =: recMgrId];
        Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        System.runAs(recMgr){
            IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                Name='Test Project',
                Color__c='Orange',
                Status__c ='Active',
                Project_Schedule__c  = 'Green',
                Scope__c = 'Green',
                Project_Financial__c  = 'Green',
                Project_Resources__c = 'Green',
                Project_Status__c = 'In-Progress',
                RecordTypeId = LifeCycleRecTypeId);
            insert p;
            
            IT_Resource__c r = new IT_Resource__c(
                Name='Test Resource',
                Roles__c =Roles,
                Role__c = Role,
                Employee__c = recEmployee.Id);
            
            insert r;

        String effort = 'High';
        String status = 'Active';

        Test.startTest();
        ganttChartRM.saveAllocation(null, p.Id, r.Id, effort, status, String.valueOf(dt.getTime()), String.valueOf(dt.getTime()), 40);
        Test.stopTest();

        List<Team_Assignment__c> allocations = [SELECT Id, Life_Cycle__c, IT_Resource__c, Effort__c, Status__c, Start_Date__c, End_Date__c
                                           FROM Team_Assignment__c];
        System.assertEquals(1, allocations.size());
        System.assertEquals(p.Id, allocations.get(0).Life_Cycle__c);
        System.assertEquals(r.Id, allocations.get(0).IT_Resource__c);
        System.assertEquals(effort, allocations.get(0).Effort__c);
        System.assertEquals(status, allocations.get(0).Status__c);
        }
    }
    
    @isTest
    static void ganttChart_saveAllocation_update() {
        Date d = Date.today();
        DateTime dt = DateTime.now();
        User recEmployee = tst_ganttChartRM.getRecUser();
        Id recMgrId = recEmployee.Mgr__c;
        User recMgr = [select Id from User where Id =: recMgrId];
        Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        System.runAs(recMgr){
            IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                Name='Test Project',
                Color__c='Orange',
                Status__c ='Active',
                Project_Schedule__c  = 'Green',
                Scope__c = 'Green',
                Project_Financial__c  = 'Green',
                Project_Resources__c = 'Green',
                Project_Status__c = 'In-Progress',
                RecordTypeId = LifeCycleRecTypeId);
            insert p;
            
            IT_Resource__c r = new IT_Resource__c(
                Name='Test Resource',
                Roles__c = Roles,
                Role__c = Role,
                Employee__c = recEmployee.Id);
            insert r;
            
            String effort = 'High';
            //String status = 'Unavailable';
            String status = 'Hold';
            Team_Assignment__c a = new Team_Assignment__c(
                Life_Cycle__c  = p.Id,
                IT_Resource__c  = r.Id,
                Start_Date__c = d,
                End_Date__c = d,
                Effort__c = effort,
                Status__c = 'Active',
                Role__c = Role,
                Number_of_Hours__c = 40);
            insert a;

        Test.startTest();
        ganttChartRM.saveAllocation(a.Id, null, r.Id, effort, status, String.valueOf(dt.getTime()), String.valueOf(dt.getTime()),40);
        Test.stopTest();

        List<Team_Assignment__c> allocations = [SELECT Id, Life_Cycle__c, IT_Resource__c, Effort__c, Status__c, Start_Date__c, End_Date__c
                                           FROM Team_Assignment__c];
        System.assertEquals(1, allocations.size());
        System.assertEquals(a.Id, allocations.get(0).Id);
        System.assertEquals(p.Id, allocations.get(0).Life_Cycle__c);
        System.assertEquals(r.Id, allocations.get(0).IT_Resource__c);
        System.assertEquals(effort, allocations.get(0).Effort__c);
        System.assertEquals(status, allocations.get(0).Status__c);
        }
    }

    @isTest
    static void ganttChart_deleteAllocation() {
        Date d = Date.today();        
        User recEmployee = tst_ganttChartRM.getRecUser();
        Id recMgrId = recEmployee.Mgr__c;
        User recMgr = [select Id from User where Id =: recMgrId];
        Id LifeCycleRecTypeId = Schema.SObjectType.IT_Portfolio_Management__c.getRecordTypeInfosByName().get('Initiation').getRecordTypeId();
        System.runAs(recMgr){
            IT_Portfolio_Management__c p = new IT_Portfolio_Management__c(
                Name='Test Project',
                Color__c='Orange',
                Status__c ='Active',
                Project_Schedule__c  = 'Green',
                Scope__c = 'Green',
                Project_Financial__c  = 'Green',
                Project_Resources__c = 'Green',
                Project_Status__c = 'In-Progress',
                RecordTypeId = LifeCycleRecTypeId);
            insert p;
            
            IT_Resource__c r = new IT_Resource__c(
                Name='Test Resource',
                Roles__c =Roles,
                Role__c = Role,
                Employee__c = recEmployee.Id);
            
            insert r;
            
            Team_Assignment__c a = new Team_Assignment__c(
                Life_Cycle__c  = p.Id,
                IT_Resource__c  = r.Id,
                Start_Date__c = d,
                End_Date__c = d,
                Role__c = Role,
                Number_of_Hours__c = 40);
            insert a;
        Test.startTest();
        ganttChartRM.deleteAllocation(a.Id);
        Test.stopTest();
        List<Team_Assignment__c> allocations = [SELECT Id FROM Team_Assignment__c];

        System.assertEquals(0, allocations.size());
        }
    }
}