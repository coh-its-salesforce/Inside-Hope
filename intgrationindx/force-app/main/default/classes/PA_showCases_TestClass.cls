@isTest
    private class PA_showCases_TestClass {

        static testMethod void myUnitTest1() {
            PA_ShowCases p = new PA_ShowCases();
            
        }

         static testMethod void myUnitTest2() {
            Account a = new Account();
            a.Name = 'test';
            insert a;
            
            Case c = new Case();
            c.AccountId = a.id;
            c.Complaint_Category__c = 'Complaint';
            insert c;
            
            c.Assign_To__c = UserInfo.getUserId();
            update c;
            
        }
    }