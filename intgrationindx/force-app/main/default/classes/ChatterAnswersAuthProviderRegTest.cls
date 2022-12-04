@isTest
private class ChatterAnswersAuthProviderRegTest {
    static testMethod void validateCreateUpdateUser() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Auth.UserData userData = new Auth.UserData('testId', 'testFirst', 'testLast',
            'testFirst testLast', 'no-reply@salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
            null, new Map<String, String>{'language' => 'en_US'});
            ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
            Profile[] p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            Profile someProfile = [SELECT Id FROM Profile WHERE Name = 'Visiting Scholar Program' LIMIT 1];
            User[] adminUser = [SELECT Id, Firstname, Lastname FROM User WHERE IsActive = true and ProfileId =: p[0].Id LIMIT 1];
            reg.setSiteAdminUserId(adminUser[0].Id);
            User newUser = reg.createUser(null, userData);
            System.assert(newUser != null, 'A new user should have been created');
            System.assertEquals(newUser.Firstname, 'testFirst', 'First name should have been same');
            System.assertEquals(newUser.Lastname, 'testLast', 'Last name should have been same');
            System.assertEquals(newUser.Email, 'no-reply@salesforce.com', 'Email should have been same');
            
            Contact c = new Contact();
            c.AccountId = (newUser.Username.split('@'))[0];
            c.LastName = 'contactLast';
            insert(c);
            
            newUser.Alias = 'firstusr';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.LocaleSidKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.ContactId = c.Id;
            newUser.profileId = someProfile.Id;
            // testing--raymond tam
            newUser.UserRoleId = [Select Id From UserRole Where PortalType = 'None' Limit 1].Id;   
            newUser.PortalRole = 'Manager';
//            newUser.PortalRole = [select Id from UserRole where name = 'Visiting International Scholars for Surgery Customer Manager' limit 1].Id;
/*
            insert(newUser);
            
            
            Auth.UserData updateUserData = new Auth.UserData('testId', 'updatedFirst', 'updatedLast',
            'updatedFirst updatedLast', 'no-reply@new.salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
            null, new Map<String, String>{'language' => 'en_US'});
            reg.updateUser(newUser.Id, null, updateUserData);
            
            User dbUser =  [SELECT Id, Firstname, Lastname, Email FROM User WHERE Id = :newUser.Id];
            System.assertEquals(dbUser.Firstname, 'updatedFirst', 'First name should have been updated');
            System.assertEquals(dbUser.Lastname, 'updatedLast', 'Last name should have been updated');
            System.assertEquals(dbUser.Email, 'no-reply@new.salesforce.com', 'Email should have been updated');
*/
        }
    }
    
//    static testMethod void foo() {
    static void foo() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Auth.UserData userData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                       'testFirst testLast', 'no-reply@salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
                                                       null, new Map<String, String>{'language' => 'en_US'});
            ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
            Profile[] p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            Profile someProfile = [SELECT Id FROM Profile WHERE Name = 'Visiting Scholar Program' LIMIT 1];
            User[] adminUser = [SELECT Id, Firstname, Lastname FROM User WHERE IsActive = true and ProfileId =: p[0].Id LIMIT 1];
            reg.setSiteAdminUserId(adminUser[0].Id);
          
            List<UserRole> userRoleList = [select id, name, portaltype from userrole];
    
            User newUser = reg.createUser(null, userData);
            System.assert(newUser != null, 'A new user should have been created');
            System.assertEquals(newUser.Firstname, 'testFirst', 'First name should have been same');
            System.assertEquals(newUser.Lastname, 'testLast', 'Last name should have been same');
            System.assertEquals(newUser.Email, 'no-reply@salesforce.com', 'Email should have been same');
            
            Contact c = new Contact();
            c.AccountId = (newUser.Username.split('@'))[0];
            c.LastName = 'contactLast';
            insert(c);
            
            for (UserRole userRoleObj : userRoleList)    {
                newUser.Alias = 'firstusr';
                newUser.TimeZoneSidKey = 'America/Los_Angeles';
                newUser.LocaleSidKey = 'en_US';
                newUser.EmailEncodingKey = 'UTF-8';
                newUser.LanguageLocaleKey = 'en_US';
                newUser.ContactId = c.Id;
                newUser.profileId = someProfile.Id;
                newUser.PortalRole = 'Manager';
                newUser.UserRoleId = userRoleObj.Id;
               
                
                //System.debug('Tracer: newUser.UserType--> ' + newUser.UserType);
                System.debug('Tracer: userRoleObj.PortalType--> ' + userRoleObj.PortalType);
                

                
                try {
                    
                    insert(newUser);
                    System.debug('Tracer1: -------valid userRoleObj.Id--> ' + userRoleObj.Id);
                    break;
                    
                } catch (Exception e) {
                    System.debug('Tracer: exception caught.  userRoleObj.Name (' + userRoleObj.Name + ') --> ' + e.getMessage());
                }
                
            }    
        }        
    }
}