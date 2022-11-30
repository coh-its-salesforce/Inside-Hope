/*
 * This contains the Gift Card related functionalities.
 * 
 * Pavani Vunnam
 * City of Hope
 * Copyright (c) 2014
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
@isTest
public class VIA_nominationcontroller1Test{
   public static integer remainingBalance=375;
    /* This test method will test the VIA_NominationController1 functionality.
  */
   public static string GiftCardRecordType = 'Gift Card';
   public static string VALUESINACTION = 'Values_In_Action__c';
   static testmethod void VIATest(){
       
       Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name ='System Administrator'];
      
       User testMgr = new User(Alias = 'tdusr',
                           Email = 'pvunnam123@coh.org',
                           EmailEncodingKey = 'UTF-8',
                           LastName = 'Vunnam1',
                           Firstname ='Pavani23',
                           LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US',
                           ProfileId = adminProfile.id, 
                           VIA_Nominator_Total_Amount__c = 100,                            
                           TimezoneSidKey = 'America/Los_Angeles',                             
                           UserName = 'sasingh123@coh.org',
                           Mgr__c =userinfo.getUserId(),
                           title = 'Testtitle',
                           isActive = true,
                           Per_Status__c = 'E');
        insert testMgr;   
        User u1=[select id,Name,title from user where Mgr__c =:userinfo.getUserId() and IsActive=true limit 1];
        User testUser1 = new User(Alias = 'tdusr1',
                           Email = 'pvunnam1234@coh.org',
                           EmailEncodingKey = 'UTF-8',
                           LastName = 'Vunnam132',
                           Firstname ='Pavani23',
                           LanguageLocaleKey = 'en_US',
                           LocaleSidKey = 'en_US',
                           ProfileId = adminProfile.id, 
                           VIA_Nominator_Total_Amount__c = 100,                            
                           TimezoneSidKey = 'America/Los_Angeles',                             
                           UserName = 'sasingh12356@coh.org',
                           title = 'Testtitle',
                           isActive = true,
                           Mgr__c = testMgr.id,
                           Per_Status__c = 'E');
        
        
        insert testUser1;
       
		List <User> testUsersList  = new list<user>();
		for (integer i=0; i<7; i++){
            User testUserNominee = new User(Alias = 'tdusr1',
                                            Email = 'pvunnam1234'+i+'@coh.org',
                                            EmailEncodingKey = 'UTF-8',
                                            LastName = 'Vunnam132'+i,
                                            Firstname ='Pavani23'+i,
                                            LanguageLocaleKey = 'en_US',
                                            LocaleSidKey = 'en_US',
                                            ProfileId = adminProfile.id,
                                            VIA_Nominator_Total_Amount__c = 100,                           
                                            TimezoneSidKey = 'America/Los_Angeles',                            
                                            UserName = 'sasingh12356'+i+'@coh.org',
                                            title = 'Testtitle',
                                            isActive = true,
                                            Mgr__c = testMgr.id,
                                            Per_Status__c = 'E');
            testUsersList.add(testUserNominee);
        }             
       	insert testUsersList;
  
       	User u=[select id,Name,title from user where Mgr__c =:testMgr.Id and IsActive=true Limit 1];
        list <user> testUserGroup = [select id, Name, Title from user where Mgr__c =: testMGR.Id and isActive=true];
      
      
       /*GfValues__mdt Gfmdt = new GfValues__mdt( Values__c = 'ecard-$25;$25;$20');
       insert Gfmdt ;*/
       
       system.runAs(testMgr){
            /*supported_by__c sup = new supported_by__c();
            sup.Supported_User__c = testUser.id;
            sup.Supported_By_User__c = testUser1.id;
            sup.Allow_Assistant_to_Nominate_Gift_Card__c = true;
            insert sup;
            system.debug('Users** '+[select Name,Mgr__c,Per_Status__c from user where id IN: userList]);*/
           id recTypeId=COHUtil.getRecordType(VALUESINACTION, GiftCardRecordType);
           Values_In_Action__c gf = new Values_In_Action__c();
           gf.User__c= testUser1.id;
           gf.Gift_Card_Amount__c ='$25';
           gf.Describe_how_nominee_goes__c ='abcdef';
           gf.Type__c = 'Gift Card';
           gf.Gift_Card_Type__c= 'Amazon';
           gf.Title__c = 'abcded';
           gf.First_and_Last_Name__c=u1.Name;
           gf.RecordTypeId=recTypeId;
           insert gf;
           system.debug('gf values'+gf);
           
           
           Values_In_Action__c v = new Values_In_Action__c();
           
           ApexPages.StandardController std = new ApexPages.StandardController(v);
           /*VIA_valuesinactionController via = new VIA_valuesinactionController(std);
           via.save();
           v.User__c= UserInfo.getUserId();
           via.getcategoryList();
           via.modifyTD();
           v.Describe_how_nominee_goes__c ='';
           via.save();
           v.Describe_how_nominee_goes__c ='abcd';
           v.Individual_Category__c ='';
           via.save();
           v.Individual_Category__c ='adbcd';
           via.save();*/
           
           v = new Values_In_Action__c();
           v.User__c= testuser1.id;
           v.Gift_Card_Amount__c ='$10';
           v.Describe_how_nominee_goes__c ='abcdef';
           v.Type__c = 'Gift Card';
           v.Gift_Card_Type__c= 'Starbucks';
           v.Title__c = 'abcded';
           v.Pick_up_location__c='4920 Rivergrade 17.0407';
           //v.I_Agree__c=true;
           std = new ApexPages.StandardController(v);
           VIA_NominationController1 gf1 = new VIA_NominationController1(std);
           gf1.save();
           gf1.acknowledge = true;
           gf1.save();
           gf1.GCSelectedUser =u.Name;
           gf1.modifyTD();
           //gf1.ReportNavigation();
           gf1.amoutValues();
           system.debug('gf1 amount'+gf1.balamt);
            // It will check the remaining balance for the current year after deducting all the consumed amount.
           system.assertEquals(remainingBalance, gf1.balAmt);
           
           
           //creating a group gift card request
           Values_In_Action__c v2 = new Values_In_Action__c();
           v2= new Values_In_Action__c();
           v2.User__c= testuser1.id;
           v2.Gift_Card_Amount__c ='$10';
           v2.Describe_how_nominee_goes__c ='abcdef';
           v2.Type__c = 'Gift Card';
           v2.Gift_Card_Type__c= 'Starbucks';
           v2.Title__c = 'abcded';
           v2.Pick_up_location__c='4920 Rivergrade 17.0407';
           ApexPages.StandardController std2 = new ApexPages.StandardController(v2);
           std2 = new ApexPages.StandardController(v2);
           VIA_NominationController1 gf2 = new VIA_NominationController1(std2);
           gf2.GCSelectedUser ='['+u.Name+','+testUserGroup[1].Name+','+testUserGroup[2].Name+','+testUserGroup[3].Name+','+testUserGroup[4].Name+','+testUserGroup[5].Name+']';
           //gf2.save();
           gf2.acknowledge = true;
           //gf2.save();
           system.debug('GC Selected User in Test Class = ' +gf2.GCSelectedUser);
           gf2.modifyTD();
           gf2.save();
           
           //creating a group egift card request
           Values_In_Action__c v3 = new Values_In_Action__c();
           v3= new Values_In_Action__c();
           v3.User__c= testuser1.id;
           v3.Gift_Card_Amount__c ='ecard-$25';
           v3.Describe_how_nominee_goes__c ='abcdef';
           v3.Type__c = 'Gift Card';
           v3.Gift_Card_Type__c= 'Starbucks';
           v3.Title__c = 'abcded';
           v3.Pick_up_location__c='4920 Rivergrade 17.0407';
           ApexPages.StandardController std3 = new ApexPages.StandardController(v3);
           std3 = new ApexPages.StandardController(v3);
           VIA_NominationController1 gf3 = new VIA_NominationController1(std3);
           gf3.GCSelectedUser ='['+u.Name+','+testUserGroup[1].Name+','+testUserGroup[2].Name+','+testUserGroup[3].Name+','+testUserGroup[4].Name+','+testUserGroup[5].Name+']';
           //gf3.save();
           gf3.acknowledge = true;
           //gf3.save();
           system.debug('GC Selected User in Test Class = ' +gf3.GCSelectedUser);
           gf3.modifyTD();
           gf3.save();
           
           //creating error where giftcard amount exceeds nominator's balance.
           Values_In_Action__c v4 = new Values_In_Action__c();
           v4= new Values_In_Action__c();
           v4.User__c= testuser1.id;
           v4.Gift_Card_Amount__c ='$10';
           v4.Describe_how_nominee_goes__c ='abcdef';
           v4.Type__c = 'Gift Card';
           v4.Gift_Card_Type__c= 'Starbucks';
           v4.Title__c = 'abcded';
           v4.Pick_up_location__c='4920 Rivergrade 17.0407';
           ApexPages.StandardController std4 = new ApexPages.StandardController(v4);
           std4 = new ApexPages.StandardController(v4);
           VIA_NominationController1 gf4 = new VIA_NominationController1(std4);
           gf4.GCSelectedUser ='['+u.Name+','+testUserGroup[1].Name+','+testUserGroup[2].Name+','+testUserGroup[3].Name+','+testUserGroup[4].Name+','+testUserGroup[5].Name+']';
           //gf3.save();
           gf4.acknowledge = true;
           //gf3.save();
           system.debug('GC Selected User in Test Class = ' +gf4.GCSelectedUser);
           gf4.modifyTD();
           gf4.save();
         
       }
   }
}