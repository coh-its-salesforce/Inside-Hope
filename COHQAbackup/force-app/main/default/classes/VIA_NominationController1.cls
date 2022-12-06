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
/* Modified By                  : Saidaiah Surisetti
* Modified Date                : 13/June/2018
* Lines of Code Added/Updated  : 10-14, 54-57, 81-170(110-158 commented for reduce the lines of code), 220-223(commented), 239-269,
*                                309-314,25(as per requirement it was modified), 371-375(commented),356,359,367,342,9,74 these were also commented.
*/

public class VIA_NominationController1{
    
    public VIA_NominationController1(ApexPages.StandardSetController controller) {
        
    }
    
    public Values_In_Action__c via {get;set;}
    public set<string> supportedByUserNames{set;get;}
    public list<supported_by__c> supportedUserList{set;get;}
    public list<user> supportedByUserList{set;get;}
    public set<id> managersList{set;get;}
    public user supportedmanager{set;get;}
    public List<id> userIdList;
    private Id RecordType {get;set;}
    private String VALUESINACTION = 'Values_In_Action__c';
    private String GiftCardRecordType = 'Gift Card';
    public boolean nomineeDesc{get;set;}
    public boolean nomineeCategory{get;set;}
    public boolean usernull{get;set;}
    public List<SelectOption> getGFValues {get;set;}
    public string GFValue {get;set;}
    public List<GFValues__mdt> gfValues;
    public boolean giftcardtype{get;set;}
    public boolean giftcardamount{get;set;}
    public boolean errormsg{get;set;}
    public boolean pageMessage{get;set;}
    public Map<string,Id> GCNameIdMap;
    public string GCSelectedUser{get;set;}
    public List<SelectOption> options1{get;set;}
    public boolean acknowledge{get;set;}
    public boolean ackError{get;set;}
    public Id firstUser;
    public Decimal balAmt{get;set;}
    public Integer actualbalAmt{get;set;}
    public Map<String,Integer> gfValueMap;
    public boolean balAmtExceeds{get;set;}
    public boolean empAmtExceeds{get;set;}
    public Map<String,Integer> totAmtMap ;
    public string empAmtExceed{get;set;}
    public boolean pickupLocation{set;get;}
    public boolean saveRec {get;set;}
    public id gfRecTypeId{get;set;}
    public string delegatedUserName{get;set;}
    public string delegatedUserId{get;set;}
    public List<String> userNamesList;
    public VIA_NominationController1(){
        
    }
    public VIA_NominationController1(ApexPages.StandardController controller){
        userNamesList = new List<String>();
        delegatedUserName = '';
        delegatedUserId = '';
        via = new Values_In_Action__c();
        via = (Values_In_Action__c)controller.getRecord();
        via.Type__c = 'Gift Card';
        getGFValues = new List<SelectOption>();
        gfRecTypeId = COHUtil.getRecordType(VALUESINACTION, GiftCardRecordType);
        gfValues = [select id,MasterLabel,Values__c from GfValues__mdt];
        supportedByUserNames=new set<string>();
        supportedByUserList=new list<user>();
        supportedmanager=new user();
        nomineeDesc = false;
        ackError = false;
        acknowledge=false;
        nomineeCategory = false;
        usernull = false;
        giftcardtype = false;
        giftcardamount = false;
        errormsg = false;
        balAmtExceeds = false;
        empAmtExceeds = false;
        saveRec = false;
        pickupLocation=false;
        GCSelectedUser ='';
        empAmtExceed ='';
        balAmt = 0;
        actualbalAmt =0;
        GCUserList();
    }
    /*
* This method will fetch the sub-ordinates of a corresponding manager and put their names and id's in a map and list of select options.
*
* @param   : GCNameIdMap (stores the subordinates names and id's).
* @param   : options1 (contains the names of the sub-ordinates).
*
*/
    
    /*****changes made by sanjay-- Date 01/13/2022----- INCLUDED DELEGATED USER LOGIC AND CODE OPTIMISATION----START***/
    public void GCUserList(){
        GCNameIdMap = new Map<string,id>();
        options1 = new List<SelectOption>();
        managersList=new set<id>();
        for(supported_by__c sb:[select Supported_User__c,Supported_By_User__c,isDelegated__c
                                from supported_by__c  
                                where 
                                Supported_By_User__c =:userinfo.getuserid()
                                AND Allow_Assistant_to_Nominate_Gift_Card__c=true
                                AND Supported_User__c !=:userinfo.getUserId()])
        {
            managersList.add(sb.Supported_User__c);
        }
        
        for(supported_by__c sb:[select Supported_User__c,Supported_By_User__r.Name,Supported_By_User__c
                                from supported_by__c  
                                where isDelegated__c=true
                                AND Supported_By_User__c != :userinfo.getuserid()
                                AND Allow_Assistant_to_Nominate_Gift_Card__c = true
                                AND Supported_User__c =:userinfo.getUserId()])
        {
            delegatedUserName = sb.Supported_By_User__r.Name;
            delegatedUserId = sb.Supported_By_User__c;
        }
        /*supportedByUserList=[select id,name from user where mgr__c =:managersList and Per_Status__c = 'E' and IsActive=true ];
        for(user sbu:supportedByUserList){
            supportedByUserNames.add(sbu.name);
        }
        
        for(id managerid:managerslist){
            supportedmanager=[select Id,Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id=:managerid];
        }*/
        
        /*User loggedInUser = [SELECT Id,Delegated_User_Id__c FROM User WHERE Id =:userinfo.getUserId()];
        if(loggedInUser.Delegated_User_Id__c <> null){
            User DelegatedUser = [SELECT Id,Name FROM User WHERE Id=:loggedInUser.Delegated_User_Id__c];
            delegatedUserName = DelegatedUser.Name;
            delegatedUserId = DelegatedUser.Id;
        }*/
        Integer idx = 0;
        for(User u : [select id,Per_Status__c, Name,title 
                      from user
                      where (Mgr__c =:userinfo.getUserId() OR mgr__c IN: managersList)
                      and IsActive=true
                      and Per_Status__c = 'E'
                      ORDER BY Name])
        {
            GCNameIdMap.put(u.Name,u.id);
            options1.add(new SelectOption(u.Id,u.Name));
            if(idx == 0){
                firstUser = u.id;
            }
            idx++;
        }
        
        if(options1.size()>0)
        {
            modifyTD();
        }
    }
    /*****changes made by sanjay-- Date 01/13/2022----- INCLUDED DELEGATED USER LOGIC AND CODE OPTIMISATION----END***/
    /*
* This method will perform the calculations on gift card amount.
*
* @param   : GCSelectedUser (contains nominee names).
* @param   : gfValueMap (contains gift card amount values).
* @param   : uNameList (it will split the selected users and add their names in a list).
* @param   : userIdList (it contains userid list).
*/
    
    /*****changes made by sanjay-- Date 01/13/2022----- INCLUDED DELEGATED USER LOGIC AND CODE OPTIMISATION----START***/
    public void modifyTD(){ 
        userIdList = new List<id>();
        List<String> uNameList = new List<String>();
        string temp = label.Gift_Card_Values;
        gfValueMap = new Map<String,Integer>();
        for(string s : temp.split(',')){
            List<string> value = s.split(':');
            gfValueMap.put(value[0],Integer.ValueOf(value[1]));
        }
        system.debug(GCSelectedUser);
        if(GCSelectedUser != null && GCSelectedUser != ''){
            
            uNameList = GCSelectedUser.replace('[','').replace(']','').split(',');
        }
        userNamesList = new List<String>();
        if(GCNameIdMap != null){
            if(uNameList.size()>0){
                List<User> userId = [select id,mgr__c,Name from user where Id IN:uNameList AND mgr__c !=null];
                userIdList.add(userId[0].mgr__c);
                for(User u :userId){
                    userNamesList.add(u.Name);
                }
                
            }
            if(userIdList.isEmpty()) {
                if(!managersList.isEmpty()) userIdList.addAll(managersList);
                else userIdList.add(userinfo.getUserId());
            }
            
            for(User nUser : [select Id,Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id IN :userIdList]){
                via.Nominator_Title__c = nUser.Title;
                via.Nominator_Department__c = nUser.Department;
                via.COH_Email_Address__c = nUser.Email;
                via.Employee_ID__c = nUser.EmployeeNumber;
                via.First_and_Last_Name__c = nUser.Name;
                via.Nominator_Name__c = nUser.id;
                actualbalAmt = options1.size()*50;
                balAmt = options1.size()*50;
            }
            if(!GCNameIdMap.keySet().isEmpty()){
                for(Values_In_Action__c v : [select id,Gift_Card_Amount__c from Values_In_Action__c where 
                                             User__c IN:GCNameIdMap.values() 
                                             and RecordTypeId =:gfRecTypeId 
                                             and CreatedDate=THIS_YEAR])
                {
                    if(v.Gift_Card_Amount__c !=null){
                        balAmt -= gfValueMap.get(v.Gift_Card_Amount__c);
                        actualbalAmt -= gfValueMap.get(v.Gift_Card_Amount__c);
                    }
                }
            }
            firstUser =null;
        }
        else{
            via.Department__c = ' ';
            via.Title__c = ' ';
        }
    }
    /*****changes made by sanjay-- Date ----- INCLUDED DELEGATED USER LOGIC AND CODE OPTIMISATION----END***/
    
    /*
* This method will compare the amount values in Label and end user entered amount.
*
* @param  : gfValues (It contains gift card values in a Label).
* @param  : getGFValues ( a list of gift card amount values after filtered the type of a gift card).
*
*/
    public void amoutValues(){
        getGFValues = new List<SelectOption>();
        /*-- Changes made by Sanjay----Date-06/05/2020---START--*/
        via.Gift_Card_Amount__c = '';
        /*-- Changes made by Sanjay----Date-06/05/2020---END--*/
        for(GfValues__mdt gf : gfValues){
            if(via.Gift_Card_Type__c == gf.MasterLabel){
                for(String s : gf.Values__c.split(';')){
                    getGFValues.add(new SelectOption(s,s));
                }
            }
        }
    }
    
    public List <Values_In_Action__c> getVIArecords(){
        List <Values_In_Action__c> sortedVIARecords = New List <Values_In_Action__c>([Select ID, Name, CreatedDate from Values_In_Action__c order by createdDate]);
        Return sortedVIARecords;
    }
    
    
    /*
* This method is to save the record and it will check the data properly and it throws an error if necessary information is not found .
*/
    public Pagereference save(){
        
        nomineeDesc = false;
        nomineeCategory = false;
        usernull = false;
        errormsg = false;
        giftcardtype = false;
        giftcardamount = false;
        ackError = false;
        balAmtExceeds = false;
        pickupLocation=false;
        List<Values_In_Action__c> viaList = new List<Values_In_Action__c>();
        Set<id> empIdSet = new Set<id>();
        totAmtMap = new Map<String,Integer>();
        balAmt = actualbalAmt;
        if(via.Describe_how_nominee_goes__c ==''){
            nomineeDesc = true;        
        }
        
        if(!acknowledge){
            ackError = true;
        }
        if(via.Gift_Card_Type__c== null){
            giftcardtype = true;
        }
        
        if(via.Gift_Card_Amount__c== null){
            giftcardamount = true;
        }
        
        
        /***** changes made by sanjay-- Date 10/05/2020----- Description length check logic START----***/
        String pageName = ApexPages.currentPage().getParameters().get('currentvfpage');
        
        if(pageName  != null && 'COH_GiftCard'.equalsIgnoreCase(pageName) && string.isNotBlank(via.Describe_how_nominee_goes__c) && via.Describe_how_nominee_goes__c.length() > 250){
            errormsg = true;
        }
        /***** changes made by sanjay-- Date 10/05/2020----- Description length check logic END----***/
        
        //Saidaiah surisetti updated the below if condition to make the field mandatory if the condition satisfy.
        if(via.Pick_up_location__c== null && via.Gift_Card_Amount__c != null &&  !via.Gift_Card_Amount__c.contains('ecard')){//&& via.Gift_Card_Amount__c!='ecard-$10'
            pickupLocation=true;
        }
        if(GCSelectedUser == null || GCSelectedUser == '[]' || (GCSelectedUser <> null && (string.isBlank(GCSelectedUser) 
          || string.isEmpty(GCSelectedUser)))){
            usernull = true;
        }
        else{
            system.debug('GCSelectedUser = ' + GCSelectedUser);
            for(String s : GCSelectedUser.replace('[','').replace(']','').split(',')){
                if(GCSelectedUser.replace('[','').replace(']','').split(',').size()>5){
                    Values_In_Action__c via1            = new Values_In_Action__c();
                    Via1.Gift_Card_Type__c              = Via.Gift_Card_Type__c ;
                    Via1.Gift_Card_Amount__c            = Via.Gift_Card_Amount__c;
                    Via1.Gift_Card_Number__c            = Via.Gift_Card_Number__c;
                    Via1.Title__c                       = Via.Title__c;
                    Via1.Department__c                  = Via.Department__c;
                    Via1.Describe_how_nominee_goes__c   = Via.Describe_how_nominee_goes__c; 
                    Via1.First_and_Last_Name__c         = Via.First_and_Last_Name__c;
                    Via1.Employee_ID__c                 = Via.Employee_ID__c;
                    Via1.COH_Email_Address__c           = Via.COH_Email_Address__c;
                    Via1.Nominator_Title__c             = Via.Nominator_Title__c;
                    Via1.Nominator_Department__c        = Via.Nominator_Department__c;
                    Via1.Nominator_Name__c              = Via.Nominator_Name__c;
                    via1.Type__c                        = 'Gift Card';
                    via1.User__c                        = s;//GCNameIdMap.get(s.trim());
                    via1.Pick_up_location__c = via.Pick_up_location__c;
                    via1.Recordtypeid                   = gfRecTypeId;
                    via1.Type_of_Nominee__c             = 'Group';
                    viaList.add(via1);             
                    balAmt                              -= gfValueMap.get(Via.Gift_Card_Amount__c);
                    empIdSet.add(GCNameIdMap.get(s.trim()));  
                }
                Else{
                    system.debug('GCSelectedUser in individual group = ' + GCSelectedUser);
                    Values_In_Action__c via1            = new Values_In_Action__c();
                    Via1.Gift_Card_Type__c              = Via.Gift_Card_Type__c ;
                    Via1.Gift_Card_Amount__c            = Via.Gift_Card_Amount__c;
                    Via1.Gift_Card_Number__c            = Via.Gift_Card_Number__c;
                    Via1.Title__c                       = Via.Title__c;
                    Via1.Department__c                  = Via.Department__c;
                    Via1.Describe_how_nominee_goes__c   = Via.Describe_how_nominee_goes__c; 
                    Via1.First_and_Last_Name__c         = Via.First_and_Last_Name__c;
                    Via1.Employee_ID__c                 = Via.Employee_ID__c;
                    Via1.COH_Email_Address__c           = Via.COH_Email_Address__c;
                    Via1.Nominator_Title__c             = Via.Nominator_Title__c;
                    Via1.Nominator_Department__c        = Via.Nominator_Department__c;
                    Via1.Nominator_Name__c              = Via.Nominator_Name__c;
                    via1.Type__c                        = 'Gift Card';
                    via1.User__c                        = s;//GCNameIdMap.get(s.trim());
                    via1.Pick_up_location__c            = via.Pick_up_location__c;
                    via1.Recordtypeid                   = gfRecTypeId;
                    via1.Type_of_Nominee__c             = 'Individual';       
                    viaList.add(via1);
                    balAmt                              -= gfValueMap.containsKey(Via.Gift_Card_Amount__c) ? gfValueMap.get(Via.Gift_Card_Amount__c) : 0; 
                    empIdSet.add(GCNameIdMap.get(s.trim()));   
                }
            }    
        }
        if(balAmt <0){
            
            balAmtExceeds = true;  
        }
        
        if(usernull || nomineeDesc || errormsg || ackError || giftcardtype || giftcardamount || balAmtExceeds || pickupLocation){
            system.debug('Before Null' );
            return null;
        }
        for(Values_In_Action__c via : [select id,User__r.Name,User__c, Gift_Card_Amount__c,ownerId from Values_In_Action__c where User__c IN :empIdSet
                                       and CreatedDate =THIS_YEAR and RecordTypeId =:gfRecTypeId]){
                                           if(totAmtMap.containsKey(via.User__r.Name)){
                                               Integer amt = totAmtMap.get(via.User__r.Name);
                                               if(via.Gift_Card_Amount__c !=null){
                                                   totAmtMap.put(via.User__r.Name,gfValueMap.get(via.Gift_Card_Amount__c)+amt);
                                               }
                                               system.debug('amt = '+amt);
                                               system.debug('via GiftCardAmount = '+via.Gift_Card_Amount__c);
                                               system.debug('totAMTMap = '+totAmtMap);
                                               system.debug('gfValueMap = '+ gfValueMap);
                                           }else{
                                               if(via.Gift_Card_Amount__c !=null){
                                                   totAmtMap.put(via.User__r.Name,gfValueMap.get(via.Gift_Card_Amount__c));
                                               }
                                           }
                                       }
        for(string s : totAmtMap.keySet()){
            if(via.Gift_Card_Amount__c != null && gfValueMap.containsKey(via.Gift_Card_Amount__c) && totAmtMap.get(s)+gfValueMap.get(via.Gift_Card_Amount__c) > 75){
                empAmtExceed += s+'\n';
                empAmtExceeds = true;
            }
            
        }
        
        if(empAmtExceeds && !saveRec){
            system.debug('Line 374 after Saverec Null' ); 
            return null;
        }
        
        else{
            try{
                insert viaList;  
            } catch(Exception e){
                pageMessage =true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                return null;  
            }
        }        
        //Send a single email if the request goes to more than 5 nominees. This reduces the number of emails incase a supervisor plans to issue out more than five gift cards and is NOT an Ecard.
        if(GCSelectedUser.replace('[','').replace(']','').split(',').size()>5){
            List<Values_In_Action__c> viaNameList = [select name from Values_In_Action__c where ID IN:viaList];
            List<String> VIARecordName = new list<string>();
            system.debug('viaNameList contains'+viaNameList);
            for(Values_in_action__c v: viaNameList){
                system.debug('variable name =' + v.name);
                system.debug('VIARecordName =' + VIARecordName);
                VIARecordName.add(v.name);           
            }
            user NominatorUser = [select id, email from user where id =: via.Nominator_Name__c];
            integer listsize = viaNameList.size();
            list<Values_in_Action__c> groupVIAList = [select id, Pick_up_location__c, Gift_Card_Amount__c, Describe_how_nominee_goes__c from Values_in_Action__c where id =: viaList];
            list<Values_in_Action__c> groupVIAListtoUpdate = new list <Values_in_Action__c>();
            for(Values_in_Action__c gVIARecord: groupVIAList){
                gVIARecord.Describe_how_nominee_goes__c += ' Reference information '+ VIARecordName[0]+' - ' + VIARecordName[listsize-1];
                groupVIAListtoUpdate.add(gVIARecord);
            }
            if(COHUtil.isValidList(groupVIAListtoUpdate)){
                update groupVIAListtoUpdate;
            }
            List<String> toAddresses = new List<String> {via.COH_Email_Address__c};
                //List<String> toAddresses = new List<String> {'hgevondyan@coh.org'};
                //List<String> toAddresses = new List<String> {'sasingh@coh.org'};
                toAddresses.add('recognition@coh.org');
            if(via.Gift_Card_Amount__c!='ecard-$25' && via.Gift_Card_Amount__c!='ecard-$10'){
                system.debug('This is going through the email process for non-eCards.');
                Messaging.SingleEmailMessage email = COHUtil.createEmailMessage(null, null, 'recognition@coh.org',  
                                                                                toAddresses, 'Confirmation receipt of Non-Cash Award Request','<html><body>Thank you for your group submission of ' + GCSelectedUser.replace('[','').replace(']','').split(',').size() + ' selected individuals. The selected individuals are ' + string.join(userNamesList,',') +'.<br><br> Please allow up to three business days to process your order. The ' + via.Gift_Card_Type__c +' gift cards valued at '+ via.Gift_Card_Amount__c + ' each, will be sent to the employee’s City of Hope email address directly along with your message. <br><br> Any changes to your order, contact recognition@coh.org for assistance. <br><br> Thank you! <br><br> Reference information '+ VIARecordName[0]+' - ' + VIARecordName[listsize-1]+'</body>');  
                if(email!=null){
                    try{
                        Messaging.SendEmailResult[]results=Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});}
                    catch(Exception e){
                        pageMessage = true;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
                        system.debug('Exception 418' + e.getMessage() );
                    }
                }
            }
            else{
                system.debug('This is going through the Email process for $25 ecards');
                Messaging.SingleEmailMessage email = COHUtil.createEmailMessage(null, null, 'recognition@coh.org',  
                                                                                toAddresses, 'Confirmation receipt of Non-Cash Award Request','<html><body>Thank you for your group submission of ' + GCSelectedUser.replace('[','').replace(']','').split(',').size() + ' selected individuals. The selected individuals are ' + string.join(userNamesList,',') +'.<br><br> Please allow up to three business days to process your order. The ' + via.Gift_Card_Type__c +' gift cards valued at '+ via.Gift_Card_Amount__c + ' each, will be sent to the employee’s City of Hope email address directly along with your message. <br><br> Any changes to your order, contact recognition@coh.org for assistance. <br><br> Thank you! <br><br> Reference information '+ VIARecordName[0]+' - ' + VIARecordName[listsize-1]+'</body>');
                if(email!=null){
                    try{
                        Messaging.SendEmailResult[]results=Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});}
                    catch(Exception e){
                        pageMessage = true;
                        system.debug('Exception Send mail result' + e.getMessage() );
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
                    }
                }
            }
        }
        /***** changes made by sanjay-- Date 07/12/2022----- SEND EMAIL----START***/
        sendEmail();
        /***** changes made by sanjay-- Date 07/12/2022----- SEND EMAIL----END***/
        //Redirects to the Confirmation Page.
        PageReference ConDetailPage =  new PageReference('/apex/COH_GiftCard_Confirmation_Page');
        ConDetailPage.setredirect(true);
        return ConDetailPage;
        
    }
    
    /***** changes made by sanjay-- Date 07/12/2022----- SEND EMAIL----START***/
    void sendEmail() {
        List<string> uNameList = GCSelectedUser.replace('[','').replace(']','').split(',');
        if(uNameList == null || uNameList.isEmpty()) return;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        /*changes made by sanjay-- Date 08/17/2022 START*/
        Integer giftCardAmt = 0;
        if(gfValueMap.get(via.Gift_Card_Amount__c) != null){
            giftCardAmt = gfValueMap.get(via.Gift_Card_Amount__c);
        }
        /*changes made by sanjay-- Date 12/06/2022 START*/
        OrgWideEmailAddress giftCardAddress = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName='Gift Card'];
        /*changes made by sanjay-- Date 12/06/2022 END*/
        /*changes made by sanjay-- Date 08/17/2022 END*/
        for(User userData:[SELECT Email,FirstName,Name FROM User WHERE Id IN:uNameList]){
            string htmlbody = '<html>'+
                '<body>'+
                /*'<p>Dear '+userData.Name+'</p>'+*/
                '<p>Dear '+userData.FirstName+',</p>'+
                '<br/>'+
                '<p>'+
                /* 'Your manager, '+via.First_and_Last_Name__c+', is recognizing you with a'+ */
                ''+via.First_and_Last_Name__c+' is recognizing you with a'+
                /* ' $'+string.valueOf(giftCardAmt)+' '+via.Gift_Card_Type__c+' e-gift card for your commitment to City of Hope.'+ //changes made by sanjay-- Date 08/17/2022 */
                ' $'+string.valueOf(giftCardAmt)+' '+via.Gift_Card_Type__c+' e-gift card for your commitment to City of Hope.'+ //changes made by sanjay-- Date 08/17/2022
                ' Please find a copy of their message below.'+
                '</p>'+
                '<p>'+via.Describe_how_nominee_goes__c+'</p>'+
                '<p>'+
                'The electronic gift card will be sent to your City of Hope email address within 2-3 business days from cardservices@hawkmarketplace.com'+
                '</p>'+
                '<p>Thank you for all that you do!</p>'+
                '</body>'+
                '</html>';
            /*changes made by sanjay-- Date 12/06/2022 START*/
            Messaging.SingleEmailMessage message = COHUtil.createEmailMessage(userData,null,'recognition@coh.org',null,'Gift Card',htmlbody);
            message.setOrgWideEmailAddressId(giftCardAddress.Id);
            /*changes made by sanjay-- Date 12/06/2022 END*/
            messages.add(message);
        }
        if(!Test.isRunningTest()){
            Messaging.sendEmail(messages);
        }
    }    
    /***** changes made by sanjay-- Date 07/12/2022----- SEND EMAIL----END***/
    
    
    /***** changes made by sanjay-- Date 01/13/2022----- SAVE DELEGATED USER----START***/
    public void saveDelegatedUser(){
        DELETE [select Id from supported_by__c  
                where isDelegated__c=true
                AND Supported_By_User__c != :userinfo.getuserid()
                AND Allow_Assistant_to_Nominate_Gift_Card__c = true
                AND Supported_User__c =:userinfo.getUserId()];
        if(string.isNotBlank(delegatedUserId) && string.isNotEmpty(delegatedUserId)){
            INSERT new supported_by__c(isDelegated__c=true,Allow_Assistant_to_Nominate_Gift_Card__c = true,Supported_User__c =userinfo.getUserId(),
                                       Supported_By_User__c=delegatedUserId);
        }
    }
    /***** changes made by sanjay-- Date 01/13/2022----- SAVE DELEGATED USER---- END***/
}