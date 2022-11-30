/*
* This contains the Heroes of hope related Functionality
*
* Sanjay Singh
* City of Hope
* Copyright (c) 2020
*
 * No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
* 
*/
public with sharing class COH_HeroesOfHopeController {
    
    public COH_Heroes_of_Hope__c hoh {get;set;}    
    public List<id> userIdList;
    
    public List<selectOption> availableUsers{get; set;}
    public List<SelectOption> selectedusers{get; set;}
    //public list<SelectOption> giftcardOptions {get; set;}
    
    public string userKeyword {get; set;}
    
    public string submitterTitle {get; set;}
    public string submitterDepartment {get; set;}
    public string submitterEmail {get; set;}
    public string submitterEmployeeId {get; set;}
    public string submitterName {get; set;}
    
    
    public string heroDepartment {get; set;}
    public string heroTitle {get; set;}
    public boolean submitterNameFlag{get;set;}
    public boolean submitterDesc{get;set;}
    public boolean submitterCategory{get;set;}
    public boolean usernull{get;set;}
    public boolean errormsg{get;set;}
    public boolean pageMessage{get;set;} 
    //public boolean giftCardTypeError {get;set;} 
    //public boolean giftCardAmountError {get;set;} 
    public COH_HeroesOfHopeController(ApexPages.StandardController controller){
        hoh = new COH_Heroes_of_Hope__c();
        hoh = (COH_Heroes_of_Hope__c)controller.getRecord();
        hoh.Type_of_Hero__c = 'Individual'; 
        availableUsers = new List<selectOption>();
        selectedusers = new List<selectOption>();
        //giftcardOptions = new List<selectOption>();
        submitterNameFlag = false;
        submitterDesc = false;
        submitterCategory = false;
        usernull = false;
        errormsg = false;
        //giftCardTypeError = false;
        //giftCardAmountError = false;
        for(user u : [Select id, Name, Title from User where isActive = true order by Name ASC limit 1000]){
            availableUsers.add(new SelectOption(u.Id, u.Name + ' ( '+ u.title + ' ) '));
        }
        
        submitterTitle = '';
        submitterDepartment= '';
        submitterEmail = '';
        submitterEmployeeId = '';
        submitterName = '';
        heroDepartment = '';
        heroTitle = '';
    }
    
    public List<selectOption> getcategoryList(){
        List<SelectOption> options = new List<SelectOption>();
        for(String s : Label.CategoryList.split(';')){
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    public List<selectOption> getPillerList(){
        List<SelectOption> options = new List<SelectOption>();
        for(String s : Label.HeroesOfHopePillerVaues.split(';')){
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    /* Sanjay 05/12/20202 
    public void amountValues(){
        giftcardOptions = new List<SelectOption>();
        for(HGfValues__mdt Hgf : [select id,MasterLabel,Values__c from HGfValues__mdt]){
            if(hoh.Gift_Card_Type__c == Hgf.MasterLabel){
                for(String s : Hgf.Values__c.split(';')){
                    giftcardOptions.add(new SelectOption(s,s));
                }
            }
        }
    }
    Sanjay 05/12/20202 */
    
    public void doSearchUser(){
        availableUsers = new List<selectOption>();
        Set<id> selectedIds = new Set<id>();
        if(!selectedusers.isEmpty()){
            for(SelectOption s : selectedusers){
                selectedIds.add((ID)s.getValue());
            }
        }
        if(string.isNotBlank(userKeyword)){
            string keyword = '%'+string.escapeSingleQuotes(userKeyword)+'%';
            string userQuery = 'Select id, Name,Title, EmployeeNumber from User where ( Name like : keyword  OR EmployeeNumber like :keyword ) and isActive = true order by Name ASC Limit 1000' ;
        
            for(user u : database.query(userQuery)){
                if(!selectedIds.contains(u.Id))
                    availableUsers.add(new SelectOption(String.valueOf(u.Id), u.Name + ' ( '+ u.title + ' ) '));
            }
        }else{
            
            for(user u : [Select id, Name, title from User where isActive = true and id not in : selectedIds order by Name ASC limit 1000]){
                availableUsers.add(new SelectOption(String.valueOf(u.Id), u.Name + + ' ( '+ u.title + ' ) '));
            }
            
        }
    }
    
    public void modifyTD(){  
        userIdList = new List<id>();
        if(hoh.Hero_Name__c != null || hoh.Submitter_s_Name__c!= null) {
            userIdList.add(hoh.Hero_Name__c);
            userIdList.add( hoh.Submitter_s_Name__c);
            
            for(User nUser : [select Id, Department,Mgr__c, Title,Email,EmployeeNumber,Name from User where id IN:userIdList]){
                if(nUser.Id == hoh.Submitter_s_Name__c){
                    submitterTitle = nUser.Title;
                    submitterDepartment= nUser.Department;
                    submitterEmail = nUser.Email;
                    submitterEmployeeId = nUser.EmployeeNumber;
                    /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
                    if(submitterEmployeeId == null || submitterEmployeeId == ''){
                        hoh.Submitter_s_Name__c.addError('Please select submitter with valid Employee Id');
                    }
                    /**** Changes Added by Sanjay : Date- 04/21/2020**** END******/
                    submitterName = nUser.Name;
             
                }
                if(nUser.Id == hoh.Hero_Name__c){
                    heroDepartment = nUser.Department;
                    heroTitle = nUser.Title ; 
                }
            }
        }
        else{
            heroDepartment = ' '; 
            heroTitle = ' '; 
        } 
    }
    
    public Pagereference save(){
        submitterNameFlag = false;
        submitterDesc = false;
        submitterCategory = false;
        usernull = false;
        errormsg = false;
       // giftCardTypeError = false;
      //  giftCardAmountError = false;
        /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
        boolean confirmHeroFlag = true;
        boolean confirmSubmitterFlag = true;
        /**** Changes Added by Sanjay : Date- 04/21/2020**** End******/
        List<string> userList  = new List<String>();
        //Changes made by Sanjay-06/20/2018
        //Added nominee type check
        if((hoh.Type_of_Hero__c == 'Group' && selectedusers.isEmpty()) || (hoh.Type_of_Hero__c == 'Individual' && hoh.Hero_Name__c == null)){
            usernull =true;         
        }
        if(hoh.Submitter_s_Name__c == null){
            submitterNameFlag = true;         
        }        
        if(hoh.Describe_how_Hero_goes__c ==''){
            submitterDesc = true;         
        }
        if(hoh.Individual_Category__c =='' || hoh.Individual_Category__c == null){
            submitterCategory =true;
        }
        if(hoh.Describe_how_Hero_goes__c !=' ' && hoh.Describe_how_Hero_goes__c !=null && hoh.Describe_how_Hero_goes__c.length()<=500){
            errormsg = true;
        }
       
       /* Start Sanjay 05/12/20202 if(hoh.Gift_Card_Type__c== null){
            giftCardTypeError = true;
        
        }
       
        if(hoh.Gift_Card_Amount__c== null){
           giftCardAmountError = true;
        } 
        
        
        if(usernull || submitterDesc || submitterCategory || errormsg || submitterNameFlag || giftCardTypeError ||giftCardAmountError){
            return null;
        }
        
        End Sanjay 05/12/20202 */
        
        if(usernull || submitterDesc || submitterCategory || errormsg || submitterNameFlag ){
            return null;
        }
        
                else{
        try{
            /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
            if(submitterEmployeeId == null || submitterEmployeeId == ''){
                hoh.Submitter_s_Name__c.addError('Please select submitter with valid Employee Id');
                confirmSubmitterFlag = false;
            }
            /**** Changes Added by Sanjay : Date- 04/21/2020**** End******/
             //Changes made by Sanjay-06/20/2018
            //Added nominee type check
            /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
            if(hoh.Type_of_Hero__c == 'Group'){
                confirmHeroFlag = handleGroupHero();
            }else{
                confirmHeroFlag = handleIndividualHero();
            }
            
            /**** Changes Added by Sanjay : Date- 04/21/2020**** End******/
        }catch(Exception e){
                pageMessage =true; apexpages.addMessages(e);
                return null;
            }
        }
        /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
        return (confirmSubmitterFlag && confirmHeroFlag) ? new PageReference('/apex/COH_HerosOfHopeConfirmationPage').setredirect(true) : null;
        /**** Changes Added by Sanjay : Date- 04/21/2020**** End******/
    }
    
  
    public boolean handleGroupHero(){
        /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
        boolean confirmFlag = true;
        List<String> userIDs = new List<String>();
        for(SelectOption s : selectedusers){
            userIDs.add(s.getValue());
        }
        
        Map<Id, User> userMap = new Map<Id, User>([select Id, Mgr__c, Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id IN:userIDs]);
        List<COH_Heroes_of_Hope__c> recToINsert = new List<COH_Heroes_of_Hope__c>();
        
        string error = ' Please Select Heroes with valid Employee Id: <br/>';
        for(string s : userIDs){
            if(userMap.containsKey(s)){
                if(userMap.get(s).EmployeeNumber == null || userMap.get(s).EmployeeNumber == ''){
                    confirmFlag = false;
                    error +='<a href="/'+ userMap.get(s).Id + '" target="_Blank">'+ userMap.get(s).Name +'</a><br/>';
                    continue;
                }
                COH_Heroes_of_Hope__c rec = hoh.clone();
                rec.Hero_Name__c = s;
                rec.Supervisor__c = userMap.get(s).Mgr__c ;
                rec.Describe_how_Hero_goes__c = hoh.Describe_how_Hero_goes__c;
                recToINsert.add(rec);
            }
        }
        if(!confirmFlag){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, error));
            return false;
        }
        if(!recToINsert.isEmpty()){
            database.insert(recToINsert);
        }
        return confirmFlag;
        /**** Changes Added by Sanjay : Date- 04/21/2020**** END******/
    }
    
    public boolean handleIndividualHero(){
        /**** Changes Added by Sanjay : Date- 04/21/2020**** Start******/
        boolean confirmFlag = true;
        user u = [select Id, Mgr__c, Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id =: hoh.Hero_Name__c limit 1];
        
        if(u.EmployeeNumber == null  || u.EmployeeNumber == ''){
            hoh.Hero_Name__c.addError('Please select Hero with valid Employee Id.');
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Hero with valid Employee Id.'));
            return false;
        }
        hoh.Supervisor__c = u.Mgr__c ;
        database.insert(hoh);
        return confirmFlag;
        /**** Changes Added by Sanjay : Date- 04/21/2020**** END******/
    }
}