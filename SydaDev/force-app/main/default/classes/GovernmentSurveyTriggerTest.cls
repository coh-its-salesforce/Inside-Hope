@isTest
public class GovernmentSurveyTriggerTest {
    
    @isTest
    private static void governmentSurveyTest(){
        
        Profile profile = [ Select  Id 
                            From    Profile 
                            Where   Name = 'System Administrator' 
                            limit   1 ];
                            
       
                                      
        User u=new User( Alias = 'testUser ' , 
                 Email               = 'standarduser344@testorg.coh.org',
                 FirstName           = 'testUser' ,
                 LastName            = 'Testing ' , 
                 ProfileId           = profile.Id, 
                 UserName            = 'user@unittest.com',
                 languagelocalekey='en_US', 
                 localesidkey='en_US',
                 emailencodingkey='UTF-8',
                 timezonesidkey='America/Los_Angeles',
                 isactive = true  ,
                 EmployeeNumber = '12345'
                                          
                );
        system.runas(u){
            test.startTest();
            Government_Survey__c gs = new Government_Survey__c(
                Employee_ID__c = '12345'
                );
                
            insert gs;
            test.stopTest();
        }
    }
}