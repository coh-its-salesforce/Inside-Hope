@isTest 
private class TaskRayTriggersTest {
    private static final Integer MAX_LEN = 4;
    
    static testMethod void validateCreateGroup() {
    
        //create new users--changed from Standard User to System Administrator because the tests stopped running
        //due to lack of permission to modify the TaskRay object
        Profile p  = [select id from Profile where Name = 'System Administrator'];
        
        // Generate random strings to avoid test problems that showed up
        
        String suffix = getRandomNumberString(MAX_LEN);
		String defaultAlias = 'bcsr' + suffix;
        String defaultEmail = defaultAlias + '@coh.org';
        String defaultUserName = 'mlwbcnt' + suffix + '@coh.org';
        String defaultURL = 'http://www.cityofhope.org/about-city-of-hope/locations';
        
        User[] users5 = [select Id from User where Email = :defaultEmail or UserName = :defaultUserName];
        User user5 = null; 
        if (users5.size() == 0) {
           user5 = new User(Alias = defaultAlias, Email = defaultEmail,
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName = defaultUserName,
                Linkedin_Profile__c = defaultURL,
                Duarte_Map__c = defaultURL,
                Communities_Map__c = defaultURL,
                RiverGrade_Map__c = defaultURL,
                managerId = UserInfo.getUserId());
            insert user5;
            
            user5 = [select Id from User where Id =:user5.Id];
        } else {
            user5 = [select Id from User where Id = :users5[0].Id];
        }
        
        // Generate random strings to avoid test problems that showed up
        
        String newSuffix = getRandomNumberString(MAX_LEN);
        if (newSuffix == suffix) {	// make sure we don't get a duplicate
            newSuffix = getRandomNumberString(MAX_LEN);
        }
		defaultAlias = 'bcsr' + newSuffix;
        defaultEmail = defaultAlias + '@coh.org';
        defaultUserName = 'mlwbcnt' + newSuffix + '@coh.org';
        
        User[] users1 = [select Id from User where Email = :defaultEmail or UserName = :defaultUserName];
        User user1 = null;
        if (users1.size() == 0) {
            user1 = new User(Alias = defaultAlias, Email = defaultUserName,
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName = defaultUserName,
                Linkedin_Profile__c = defaultURL,
                Duarte_Map__c = defaultURL,
                Communities_Map__c = defaultURL,
                RiverGrade_Map__c = defaultURL,
                managerId = UserInfo.getUserId());
            insert user1;
            
            user1 = [select Id from User where Id =:user1.Id];
        } else {
            user1 = [select Id from User where Id = :users1[0].Id];
        }

        System.runAs(user5) {
        
            //create new Project record
            TASKRAY__Project__c project = new TASKRAY__Project__c
            (Name='Test01092018',
            OwnerId=user5.Id,
            taskray_project_number__c='TestTask01092018', 
            taskray_requestor_email__c='standarduser3@coh.org', 
            taskray_client_email__c='standarduser5@coh.org');
            
            insert project;
            
            project = [select ID from TASKRAY__Project__c where ID =:project.ID];
            
            //create new TaskRay record
            TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c
            (TASKRAY__Project__c = project.ID, 
            Name='TestProject01092018',
            taskray_chatter_group__c = true);
            
            Test.startTest();
            insert task;
            
            
            //update TaskRay record
            task.taskray_Secondary_Owner__c = user1.Id;
            task.taskray_chatter_group__c = true;
            //task.taskray_third_owner__c = user2.Id;
            String taownerId = task.OwnerId;
            update task;
            
            
            //archive project record
            project.TASKRAY__Status__c = true;
            
            
            update project;
            //create new Chatter Group with same name projectid-TaskName
            String chatterGroupName = 'TestTask01092018-TestProject01092018';
            chatterGroupName = chatterGroupName.left(39);
            
            CollaborationGroup grp = TaskRayTriggers.CreateChatterGroup(chatterGroupName,taownerId);
            
        
            System.assertNotEquals(grp, null);
            TaskRayTriggers.AddChatterMember(grp, user1.Id);
        }
            
        Test.stopTest();
        
       
        
    }

	/*
	 * Generate a random number string for testing.  If the number is shorter
	 * than the len argument, it will be left padded with '0' characters.
	 * 
	 * @param len	Length of the final random number string.
	 * @return		Random number string.
	 * 
	 */
    private static String getRandomNumberString(Integer len) {
        String result = null;
        if (len > 0) {
            Integer tempSuffix = Math.abs(Crypto.getRandomInteger());
            result = (COHUtil.standardizeIntegerLeft(tempSuffix, '0', len)).right(len);
        }
        return result;
	}
    
}