/*
 * This test class verifies the functionality of the COH_HeroesOfHopeController class.  
 * 
 * Sanjay Singh
 * City of Hope
 * Copyright (c) 2016
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class COH_HeroesOfHopeControllerTest {
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
    
    static testmethod void herosUnitTest(){
        
        user u = [Select id, Name from User where id=:userinfo.getUserId()];
        system.runAs(u){
            COH_Heroes_of_Hope__c v = new COH_Heroes_of_Hope__c();
            v.Type_of_Hero__c = 'Group';
            ApexPages.StandardController std = new ApexPages.StandardController(v);
            COH_HeroesOfHopeController via = new COH_HeroesOfHopeController(std);
            via.userKeyword = '';
            via.doSearchUser();
            via.userKeyword = 'test';
            via.doSearchUser();
            via.selectedusers.add(new selectOption(userinfo.getUserId(), userinfo.getUserId()));
            via.doSearchUser();
            v.Hero_Name__c = UserInfo.getUserId();
            via.modifyTD();
            via.getcategoryList();
            via.save();
            via.modifyTD();
            v.Describe_how_Hero_goes__c ='';
            via.save();
            v.Describe_how_Hero_goes__c ='TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE';
            v.Individual_Category__c ='';
            via.save();
            v.Individual_Category__c ='adbcd';
            v.Type_of_Hero__c = 'Group';
            //via.amountValues();
            //v.Gift_Card_Type__c = 'Amazon';
            //v.Gift_Card_Amount__c = 'ecard-$10';
            via.save();
            
            
        }
    }
    
    static testmethod void groupherosUnitTest(){
        
        user u = [Select id, Name from User where id=:userinfo.getUserId()];
        system.runAs(u){
            COH_Heroes_of_Hope__c v = new COH_Heroes_of_Hope__c();
            
            ApexPages.StandardController std = new ApexPages.StandardController(v);
            COH_HeroesOfHopeController via = new COH_HeroesOfHopeController(std);
            via.selectedusers.add(new selectOption(userinfo.getUserId(), userinfo.getUserId()));
            v.Hero_Name__c = UserInfo.getUserId();
            v.Type_of_Hero__c = 'Group';
            
            v.Describe_how_Hero_goes__c ='TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE';
            
            v.Individual_Category__c ='adbcd';
            v.Submitter_s_Name__c= userinfo.getUserId();
            via.modifyTD();
             //via.amountValues();
            //v.Gift_Card_Type__c = 'Amazon';
            //v.Gift_Card_Amount__c = 'ecard-$10';
            via.save();
            system.assertEquals(1, [select count() from COH_Heroes_of_Hope__c ]);
        }
    }
    
    static testmethod void HeroIndividualTest(){
        
        user u = [Select id, Name from User where id=:userinfo.getUserId()];
        system.runAs(u){
            COH_Heroes_of_Hope__c v = new COH_Heroes_of_Hope__c();
            v.Type_of_Hero__c = 'Individual';
            v.Hero_Name__c = UserInfo.getUserID();
            ApexPages.StandardController std = new ApexPages.StandardController(v);
            COH_HeroesOfHopeController via = new COH_HeroesOfHopeController(std);
            v.Hero_Name__c = UserInfo.getUserID();
            v.Submitter_s_Name__c = UserInfo.getUserId();
            v.Describe_how_Hero_goes__c ='TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE'+
                                            'TESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTETESTTESTETSTETSTESTTETSTE';
            
            v.Individual_Category__c ='adbcd';
            via.getPillerList();
            //via.amountValues();
            //v.Gift_Card_Type__c = 'Amazon';
            //v.Gift_Card_Amount__c = 'ecard-$10';
            via.save();
            system.assertEquals(1, [select count() from COH_Heroes_of_Hope__c ]);
        }
    }
}