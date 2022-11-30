/* 
 * This test class verifies the functionality of the COHCustomSettingPhysicianTreeMigration.
 * This is only for code coverage because the class will be used only for migrating
 * COHCasePhysicianDecisionTree Custom Settings.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2019
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COHCustSetPhysicianTreeMigrationTest {
    private static final Boolean mRunVerifyMigrationTest = false;
    
    private static final Boolean mRunAllTests = true;
    
    /* 
     * Run the migration.
     * This is mainly for code coverage reasons because the updates mainly involve sending emails.
     * 
     */
    private static testMethod void verifyMigration() {
        if (!mRunAllTests && !mRunVerifyMigrationTest) {
            System.debug('Skipping verifyMigration()');
            return;
        }
        
        Test.startTest();

        try {
	        COHCustomSettingPhysicianTreeMigration.migrateCustomSettings();
        } catch (COHException e) {
            // do nothing--this is expected
        }

        
        COHCasePhysicianDecisionTree__c csObj0 = new COHCasePhysicianDecisionTree__c();
        csObj0.Name = 'Foo';
        COHCasePhysicianDecisionTree__c csObj1 = new COHCasePhysicianDecisionTree__c();
        csObj1.Name = 'Bar';
        Database.insert(csObj0);
        Database.insert(csObj1);
        
        try {
	        COHCustomSettingPhysicianTreeMigration.migrateCustomSettings();
        } catch (COHException e) {
            // do nothing--this is expected
        }

		customsettingtemp__c  newCSObj0 = new customsettingtemp__c();
        newCSObj0.Name = 'Foo';
        newCSObj0.Department__c = 'RAD ONC';
        newCSObj0.Physician__c = 'Bruce Banner';
        newCSObj0.Service_Line__c = 'Radiation';
        newCSObj0.Specialty__c = 'Gamma Rays';
        newCSObj0.Subgroup_Num__c = '123';

		customsettingtemp__c  newCSObj1 = new customsettingtemp__c();
        newCSObj1.Name = 'Foobar';
        newCSObj1.Department__c = 'MED ONC';
        newCSObj1.Physician__c = 'James Bond';
        newCSObj1.Service_Line__c = 'Intelligence';
        newCSObj1.Specialty__c = 'Nothing';
        newCSObj1.Subgroup_Num__c = '124';

        Database.insert(newCSObj0);
        Database.insert(newCSObj1);
        
        COHCustomSettingPhysicianTreeMigration.migrateCustomSettings();
        
        List<COHCasePhysicianDecisionTree__c> csList = [select id from COHCasePhysicianDecisionTree__c];
        System.assertEquals(2, csList.size());
       	Test.stopTest();
    }

}