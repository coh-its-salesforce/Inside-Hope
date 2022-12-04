/*
 * This test class verifies the functionality of the VIA_valuesinactionController class.  
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
public class VIA_valuesinactionControllerTest{
    
    @testSetup
    static void initData(){
        
        Id profileId = [Select Id from Profile where name ='System Administrator' limit 1].Id;
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'test',
                                lastName = 'lName',
                                email = uniqueName  + orgId + '@coh.org',
                                Username = uniqueName  + orgId + '@coh.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profileId
                                );
        insert tUser;
    }
    
    static testmethod void VIAGroupTest(){
        
        user u = [Select id, Name from User where id=:userinfo.getUserId()];
        system.runAs(u){
            Values_In_Action__c v = new Values_In_Action__c();
            v.Type_of_Nominee__c = 'Group';
            ApexPages.StandardController std = new ApexPages.StandardController(v);
            VIA_valuesinactionController via = new VIA_valuesinactionController(std);
            via.userKeyword = '';
            via.doSearchUser();
            via.userKeyword = 'test';
            via.doSearchUser();
            via.selectedusers.add(new selectOption(userinfo.getUserId(), userinfo.getUserId()));
            via.doSearchUser();
            v.Nominator_Name__c = UserInfo.getUserId();
            via.modifyTD();
            via.getcategoryList();
            via.save();
            via.modifyTD();
            v.Describe_how_nominee_goes__c ='';
            via.save();
            v.Describe_how_nominee_goes__c ='TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE';
            v.Individual_Category__c ='';
            via.save();
            v.Individual_Category__c ='adbcd';
            //changes made by sanjay -
            // Date 10/10/2018
            //Added group type 
            v.Type_of_Nominee__c = 'Group';
            //v.Nominator_Name__c = UserInfo.getUserId();
            system.debug('-----save called----');
            via.save();
            system.assertEquals(1, [select count() from Values_In_Action__c ]);
        }
    }
    
    static testmethod void VIAIndividualTest(){
        
        user u = [Select id, Name from User where id=:userinfo.getUserId()];
        system.runAs(u){
            Values_In_Action__c v = new Values_In_Action__c();
            v.Type_of_Nominee__c = 'Individual';
            v.User__c = UserInfo.getUserID();
            ApexPages.StandardController std = new ApexPages.StandardController(v);
            VIA_valuesinactionController via = new VIA_valuesinactionController(std);
            v.User__c = UserInfo.getUserID();
            v.Nominator_Name__c = UserInfo.getUserId();
            v.Describe_how_nominee_goes__c ='TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE';
            
            v.Individual_Category__c ='adbcd';
            via.save();
            system.assertEquals(1, [select count() from Values_In_Action__c ]);
        }
    }
}