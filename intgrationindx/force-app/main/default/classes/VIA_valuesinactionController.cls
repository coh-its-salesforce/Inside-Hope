public class VIA_valuesinactionController{
    public Values_In_Action__c via {get;set;}    
    public List<id> userIdList;
    private Id RecordType {get;set;}
    private String VALUESINACTION = 'Values_In_Action__c';
    private String VIARecordType = 'Values In Action';
    public boolean nominatorsName{get;set;}
    public boolean nomineeDesc{get;set;}
    public boolean nomineeCategory{get;set;}
    public boolean usernull{get;set;}
    public boolean errormsg{get;set;}
    public boolean pageMessage{get;set;}
    public List<selectOption> availableUsers{get; set;}
    public List<SelectOption> selectedusers{get; set;}
    public string userKeyword {get; set;}
    
    public VIA_valuesinactionController(ApexPages.StandardController controller){
        via = new Values_In_Action__c();
        via = (Values_In_Action__c)controller.getRecord();
        via.Type__c = 'value in action';
        via.RecordTypeId = COHUtil.getRecordType(VALUESINACTION, VIARecordType);
        // Changes added by Sanjay Singh  
        // Date 10-09-2018 
        // Set individual Nominee type as default on Page load  
        via.Type_Of_Nominee__c = 'Individual'; 
        // Changes added by Sanjay Singh 
        // Date 06-20-2018
        // added user option list
        availableUsers = new List<selectOption>();
        selectedusers = new List<selectOption>();
        nominatorsName = false;
        nomineeDesc = false;
        nomineeCategory = false;
        usernull = false;
        errormsg = false;
        for(user u : [Select id, Name, Title from User where isActive = true order by Name ASC limit 1000]){
            availableUsers.add(new SelectOption(u.Id, u.Name + ' ( '+ u.title + ' ) '));
        }
    }
    
    public List<selectOption> getcategoryList(){
        List<SelectOption> options = new List<SelectOption>();
        for(String s : Label.CategoryList.split(';')){
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    // Changes added by Sanjay Singh 
    // Date 05-08-2018
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
        if(via.User__c != null || via.Nominator_Name__c!= null) {
            userIdList.add(via.User__c);
            userIdList.add(via.Nominator_Name__c);
            id rtypeID = COHUtil.getRecordType(VALUESINACTION, VIARecordType);
            for(User nUser : [select Id, Department,Mgr__c, Title,Email,EmployeeNumber,Name from User where id IN:userIdList]){
                if(nUser.Id == via.Nominator_Name__c){
                    via.Nominator_Title__c = nUser.Title;
                    via.Nominator_Department__c = nUser.Department;
                    via.COH_Email_Address__c = nUser.Email;
                    via.Employee_ID__c = nUser.EmployeeNumber;
                    via.First_and_Last_Name__c = nUser.Name;
                    if(rtypeID != null)   via.RecordTypeId =rtypeID; 
                }
                else{
                    via.Department__c = nUser.Department;
                    via.Title__c = nUser.Title ; 
                }
            }
            
        }
        else{
            via.Department__c = ' '; via.Title__c = ' '; 
        } 
    }
    
    public Pagereference save(){
        nominatorsName = false;
        nomineeDesc = false;
        nomineeCategory = false;
        usernull = false;
        errormsg = false;
        List<string> userList  = new List<String>();
        //Changes made by Sanjay-06/20/2018
        //Added nominee type check
        if((via.Type_of_Nominee__c == 'Group' && selectedusers.isEmpty()) || (via.Type_of_Nominee__c == 'Individual' && via.User__c == null)){
            usernull =true;         
        }
        if(via.Nominator_Name__c == null){
            nominatorsName = true;         
        }        
        if(via.Describe_how_nominee_goes__c ==''){
            nomineeDesc = true;         
        }
        if(via.Individual_Category__c =='' || via.Individual_Category__c == null){
            nomineeCategory =true;
        }
        if(via.Describe_how_nominee_goes__c !=' ' &&via.Describe_how_nominee_goes__c !=null && via.Describe_how_nominee_goes__c.length()<=500){
            errormsg = true;
        }
        
        if(usernull || nomineeDesc || nomineeCategory || errormsg || nominatorsName){
            return null;
        }
        else{
        try{
             //Changes made by Sanjay-06/20/2018
            //Added nominee type check
            if(via.Type_of_Nominee__c == 'Group'){
                handleGroupNominee();
            }else{
                handleIndividualNominee();
            }
            
        }catch(Exception e){
                pageMessage =true; apexpages.addMessages(e);
                return null;
            }
        }
        return new PageReference('/apex/COH_Values_in_Action_Confirmation_Page').setredirect(true);
    }
    
    //Changes made by Sanjay-06/20/2018
    public void handleGroupNominee(){
        List<String> userIDs = new List<String>();
        for(SelectOption s : selectedusers){
            userIDs.add(s.getValue());
        }
        
        Map<Id, User> userMap = new Map<Id, User>([select Id, Mgr__c, Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id IN:userIDs]);
        List<Values_in_Action__c> recToINsert = new List<Values_in_Action__c>();
        for(string s : userIDs){
            if(userMap.containsKey(s)){
                Values_in_Action__c rec = via.clone();
                rec.User__c = s;
                rec.Title__c = userMap.get(s).title;
                rec.Supervisor__c = userMap.get(s).Mgr__c ;
                rec.Department__c = userMap.get(s).Department;
                rec.Describe_how_nominee_goes__c = via.Describe_how_nominee_goes__c;
                recToINsert.add(rec);
            }
        }
        if(!recToINsert.isEmpty()){
            database.insert(recToINsert);
        }
    }
    //Changes made by Sanjay-06/20/2018
    public void handleIndividualNominee(){
        user u = [select Id, Mgr__c, Department,Title,Email,EmployeeNumber,Name,VIA_Nominator_Total_Amount__c from User where id =: via.User__c limit 1];
        via.Title__c = u.title;
        via.Supervisor__c = u.Mgr__c ;
        via.Department__c = u.Department;
        database.insert(via);
    }
}