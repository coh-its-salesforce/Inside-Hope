global without sharing class COH2_FacultyProfileController {
    public COH2_Faculty__c facultyObj; 
    public COH2_Faculty_Final__c finalFacultyObj {get; set;}
    public COH2_Faculty_Final__c tempfinalFacultyObj{get; set;}
    public boolean submitDone {get;set;}
    public boolean inApproval {get;set;}
    public boolean userLeft {get; set;}
    
    /*
     * Constructor Definition
     */
    public COH2_FacultyProfileController(apexpages.StandardController controller){  
        AuthorizeUser();
        /*facultyObj = new COH2_Faculty__c();
        finalFacultyObj = new COH2_Faculty_Final__c();
        tempfinalFacultyObj = new COH2_Faculty_Final__c();
        submitDone = false;
        inApproval = false;
        userLeft = false;
        queryEmployee();*/
    }
    
    public pagereference doSave(){
        try{
            Map<String, Schema.SObjectField> fieldMap = COH2_Faculty__c.getSObjectType().getDescribe().fields.getMap();
            Map<String, Schema.SObjectField> FinalfieldMap = COH2_Faculty_Final__c.getSObjectType().getDescribe().fields.getMap();
            facultyObj = new COH2_Faculty__c();
            for(string field :FinalfieldMap.keySet()){
                if(fieldMap.containsKey(field)){
                    Schema.DescribeFieldResult facFieldDesc = fieldMap.get(field).getDescribe(); 
                    Schema.DescribeFieldResult finalFacFieldDesc = FinalfieldMap.get(field).getDescribe();
                    //check first if field is editable
                    //If Field  is Status then do nothing
                    //testing--raymond tam
                    String testField = field;
                    System.debug('----------------Tracer: testField--> ' + testField);
                    if(finalFacFieldDesc.isCustom() && finalFacFieldDesc.isUpdateable() && !field.equalsIgnoreCase('Status__c')){
                        // testing--raymond tam
//                        system.debug(finalFacultyObj.get(finalFacFieldDesc.getName())+'========='+tempfinalFacultyObj.get(finalFacFieldDesc.getName()));
                        
                        //check if field is getting changed
                        if(finalFacultyObj.get(finalFacFieldDesc.getName()) != tempfinalFacultyObj.get(finalFacFieldDesc.getName())){
                            //check if value is going to change from some value to null
                            if(finalFacultyObj.get(finalFacFieldDesc.getName()) == null){
                                //In case of checkbox  mark as uncheck
                                if(finalFacFieldDesc.getType() == Schema.DisplayType.Boolean){
                                    facultyObj.put(facFieldDesc.getname(), false);
                                    
                                }//In case of Number set -99999
                                if(finalFacFieldDesc.getType() == Schema.DisplayType.Double ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Integer||
                                       finalFacFieldDesc.getType() == Schema.DisplayType.Currency||
                                   finalFacFieldDesc.getType() == Schema.DisplayType.Percent){
                                    facultyObj.put(facFieldDesc.getname(),-99999);       
                                }
                                // In case of Text field set : '<deleted>' text value
                                else if(finalFacFieldDesc.getType() == Schema.DisplayType.MultiPicklist ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Phone ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Picklist||    
                                        finalFacFieldDesc.getType() == Schema.DisplayType.String||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.TextArea){
                                    facultyObj.put(facFieldDesc.getname(),'<deleted>');            
                                 }
                                // In case of Date field set : 1/1/1800 date value
                                else if(finalFacFieldDesc.getType() == Schema.DisplayType.Date ){
                                    facultyObj.put(facFieldDesc.getname(),Date.newInstance(1800, 1, 1));            
                                 }//for date time field - Same as date
                                else if(finalFacFieldDesc.getType() == Schema.DisplayType.DateTime ){
                                    facultyObj.put(facFieldDesc.getname(),Datetime.newInstanceGmt(1800, 1, 1));            
                                 }//In case of Email set - '<deleted>@Email.address'
                                else if(finalFacFieldDesc.getType() == Schema.DisplayType.Email ){
                                    facultyObj.put(facFieldDesc.getname(),'<deleted>@Email.address');            
                                 }
                                else {
                                    ////In case of other field  mark as Blank/Null
                                    facultyObj.put(facFieldDesc.getname(), Null);       
                                }
                            }else{ // If value is changing from some value to some other value, just add new value
                                facultyObj.put(facFieldDesc.getname(), finalFacultyObj.get(finalFacFieldDesc.getName()));
                            }
                        }else{// If there is no change in field then add -1 for number and 'null' for text field 
                            //In case of checkbox field if value is false thn set false ( because by default it is null and it will show error if we'll assign null)
                            if(finalFacFieldDesc.getType() == Schema.DisplayType.Boolean){
                                if(finalFacultyObj.get(finalFacFieldDesc.getName()) == null){
                                    facultyObj.put(facFieldDesc.getname(), false); 
                                }else{
                                    facultyObj.put(facFieldDesc.getname(), finalFacultyObj.get(finalFacFieldDesc.getName())); 
                                }
                            }else{//If not check box execute below logic-
                                // In case of Number field- if no change then set : -
                                if(finalFacFieldDesc.getType() == Schema.DisplayType.Double ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Integer||
                                       finalFacFieldDesc.getType() == Schema.DisplayType.Currency||
                                   finalFacFieldDesc.getType() == Schema.DisplayType.Percent){
                                    facultyObj.put(facFieldDesc.getname(),-1);       
                                }
                                // In case of Text field set : 'Null' text value
                                else if(finalFacFieldDesc.getType() == Schema.DisplayType.MultiPicklist ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Phone ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Picklist ||    
                                        finalFacFieldDesc.getType() == Schema.DisplayType.String ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.TextArea ||
                                        //finalFacFieldDesc.getType() == Schema.DisplayType.RichTextArea ||
                                        finalFacFieldDesc.getType() == Schema.DisplayType.Email){
                                    facultyObj.put(facFieldDesc.getname(),null);            
                                 }//In case of Email set - 'Null@Null.Null'
                                /*else if(finalFacFieldDesc.getType() == Schema.DisplayType.Email ){
                                    facultyObj.put(facFieldDesc.getname(),'Null@Null.Null');            
                                 }*/
                                 // In case of other field Do below Logic
                                else{
                                    // logic to handle lookup field need to mention here
                                    // yet-to decide
                                    
                                } 
                                
                            }
                        }
                    }else{
                    
                        if(field.equalsIgnoreCase('Name')){
                            // testing--raymond tam
                            System.debug('Tracer: entering IF clause for checking Name field');
                            if (finalFacultyObj == null) {
                                System.debug('Tracer: finalFacultyObj is null');
                            }
                            facultyObj.Name= finalFacultyObj.Name;
                            // testing--raymond tam
                            System.debug('Tracer: finished IF clause for checking Name field');
                        }
                    }
                }
            }
            // testing--raymond tam
            System.debug('Tracer: inserting facultyObj');
            
            insert facultyObj;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.confirm, 'Record Saved Successfully');
            ApexPages.addmessage(myMsg);
            submitDone = true;
        }Catch(Exception e){
            apexpages.addMessages(e);
            submitDone = false;
        }
        return null;
    }
    
    public void queryEmployee(){
        string empId = apexpages.currentPage().getparameters().get('EmpId');
        if(string.isnotBlank(empId)){
            DescribeSObjectResult describeResult = COH2_Faculty_Final__c.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet() );
            Map<String, Schema.SObjectField> ffMap = describeResult.fields.getMap();
            String query = ' SELECT ' + String.join( fieldNames, ',' ) +
                           ' FROM ' + describeResult.getName() +              
                           ' WHERE ' +' Name =:empId ' +
                           ' LIMIT 1 ' ;
            
            
            List<COH2_Faculty_Final__c> faculties = Database.query(query) ;
            Integer count = [Select count() from COH2_Faculty__c  where Name=: empId and
                                Status__c = 'Pending Approval'];
            
            if(count > 0){
                inApproval = true;
            }else{
                inApproval = false;
            }
            if(!faculties.isEmpty()){
                
                
                
                tempfinalFacultyObj = faculties[0];
                  if(tempfinalFacultyObj.Left_COH__c == 'Y'){
                    userLeft = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Employee term has ended.');
                    ApexPages.addmessage(myMsg);
                }else{
                    userLeft = false;
                    
                }        
                             
                               
                for(String fieldName : ffMap.keySet()){
                    
                    Schema.SObjectField field = ffMap.get(fieldName);
                    Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                    if(fieldDescribe.isCustom() && fieldDescribe.isUpdateable()){
                        finalFacultyObj.put(fieldDescribe.getName(), tempfinalFacultyObj.get(fieldDescribe.getName()));
                    }else{
                        if(fieldName.equalsIgnoreCase('Name')){
                            finalFacultyObj.put(fieldDescribe.getName(), tempfinalFacultyObj.get(fieldDescribe.getName()));
                        }
                    }
                }
            }
        }
    }
    /*Initialization data
     */
    private void initialize(){
       
        
    }
    
    //Function to make sure the logged in user is authorised to view the record.
    public void AuthorizeUser(){
        try {
            //Initializing variable
            facultyObj = new COH2_Faculty__c();
            finalFacultyObj = new COH2_Faculty_Final__c();
            tempfinalFacultyObj = new COH2_Faculty_Final__c();
            string empId = apexpages.currentPage().getparameters().get('EmpId');
            if (string.isNotBlank(empId))
            {
                String EmployeeNumber=[Select Id,Name, EmployeeNumber from User where Id=:Userinfo.getUserId()].EmployeeNumber;        
                String profileName=[Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
                List<PermissionSetAssignment> PermissionSetsForUser = 
                    [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Label = 'Faculty Bio Approver'];
                id FacultyApproved = [SELECT id, Name from COH2_Faculty_Final__c where Name = :empId].id;
                List<Faculty_Authorized_Users__c> FacultyAuthorizedUsers = 
                    [SELECT Id, Name FROM Faculty_Authorized_Users__c WHERE User__c = :Userinfo.getUserId() and Faculty_Approved__c = :FacultyApproved];
                
                if (!string.isEmpty(empId) && empId != EmployeeNumber && PermissionSetsForUser.size() <= 0 
                    && FacultyAuthorizedUsers.size() <= 0 && !profileName.equals('System Administrator')
                    && !profileName.equals('SFDC System Administrator'))
                {
                    throw new CustomException('You are not authorized to view details of the faculty.'); 
                    inApproval = false;
                }   
                else
                {                
                    facultyObj = new COH2_Faculty__c();
                    finalFacultyObj = new COH2_Faculty_Final__c();
                    tempfinalFacultyObj = new COH2_Faculty_Final__c();
                    submitDone = false;
                    inApproval = false;
                    userLeft = false;
                    queryEmployee();
                }
            }
            else
            {
                //inApproval = true;
                inApproval = false;
                
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    
    public class CustomException extends Exception {}

}