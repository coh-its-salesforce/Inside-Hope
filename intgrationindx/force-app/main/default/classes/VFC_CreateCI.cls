public class VFC_CreateCI {
    //Variable decleration
    public boolean showFilters{get;set;}
    public boolean showSearchResults{get;set;}
    public boolean flag{get;set;}
    public boolean created{get;set;}
    public boolean flagConflict{get;set;}
    public boolean preview{get;set;}
    public boolean conflictname{get;set;}
    public boolean conflictSno{get;set;}
    public boolean conflictAsset{get;set;}
    Public Set<String> nameSet{get;set;}
    Public List<BMCServiceDesk__BMC_BaseElement__c> ListValidateCI{get;set;}
    Public List<BMCServiceDesk__BMC_BaseElement__c> ListConflictCI{get;set;}
    Public String searchStr{get;set;}
    Public String searchResults{get;set;}
    Public String userid;
    Public String assignResults{get;set;}
    Public List<BMCServiceDesk__BMC_BaseElement__c> SearchList{get;set;}
    Public BMCServiceDesk__BMC_BaseElement__c ci{get;set;}
    Public String classsel{get;set;}
    Public List<id> lstClasses = new List<id>(); 
    public Integer rowNum{get;set;}
    Public Map<String,String> classIdName = new Map<String,String>();
    Public String classSelName{get;set;}

    //Constructor
    public VFC_CreateCI(ApexPages.StandardController controller) {
    
        ci = (BMCServiceDesk__BMC_BaseElement__c)controller.getRecord();
        
        //Initialize Lists
        ListValidateCI = new List<BMCServiceDesk__BMC_BaseElement__c >();
        ListConflictCI = new List<BMCServiceDesk__BMC_BaseElement__c >();  

        //Set Flag
        created = false;            
        
    }
    
    //Get the classes to display in Picklist
    public List<selectOption> getclasses() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('--None--','--None--'));
        
        for(BMCServiceDesk__CMDB_Class__c cl : [SELECT id,BMCServiceDesk__ClassName__c from BMCServiceDesk__CMDB_Class__c WHERE BMCServiceDesk__ClassID__c in ('COH_Desktop','COH_Laptop','COH_Tablet')]){
            options.add(new selectOption(cl.id, cl.BMCServiceDesk__ClassName__c));
            classIdName.put(cl.id, cl.BMCServiceDesk__ClassName__c);
        }
        return options;
    }
    
    //Method to Search CI's based on the search string entered by user.
    public pagereference SearchItems(){
    //Check for length of search string
    if(searchStr.length() > 1){
    string srchstr = String.escapeSingleQuotes(searchStr);
        for(BMCServiceDesk__CMDB_Class__c clas : [SELECT id,name from BMCServiceDesk__CMDB_Class__c WHERE BMCServiceDesk__ClassID__c in ('COH_Desktop','COH_Laptop','COH_Tablet')]){
            lstClasses.add(clas.id);    
        }
        
        //Create Search Query
        String query = 'SELECT name,BMCServiceDesk__ManufacturerName__c, BMCServiceDesk__Model__c, BMCServiceDesk__SerialNumber__c,BMCServiceDesk__CITag__c,BMCServiceDesk__PrimaryClient__c from BMCServiceDesk__BMC_BaseElement__c WHERE (name like '+'\'%'+srchstr+'%\'' + ' OR BMCServiceDesk__CITag__c like '+'\'%'+srchstr+'%\''+ ' OR Primary_Client_Name__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__SerialNumber__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__Model__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__ManufacturerName__c like '+'\'%'+srchstr+'%\'' + ') AND (BMCServiceDesk__CMDB_Class__c in :lstClasses)';

        //Query the search results.
        SearchList = Database.Query(query);

        //Display number of search results. 
        showSearchResults = true; 
        searchResults = 'BASE ELEMENTS ['+String.valueOf(SearchList.size())+']';
       }
       //If search string is smaller than 2 characters, show warning.
       else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Enter a Search string with minimum 2 characters.'));
       }
    return null;  
    }
    
    //Method to update CI(Assign client to CI).
    public pagereference saveme()
    { 
        try{
           //Update the CI's     
           update SearchList;          
        }  
        //Catch any Exception that Occurred.
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getmessage()));
        }
        return null;  

    }
    
    //Method to validate entries by a User.
    public pagereference validate()
    { 
        //Reset all flags.
        ListValidateCI.clear();
        flag = true;
        ListValidateCI.add(ci);
        flagConflict = false;
        conflictname = false;
        conflictSno = false;
        conflictAsset = false;
        classSelName = classIdName.get(classSel);
        
        //All fields except primary client are mandatory, show error if any field is blank
        if(ci.name == null || ci.BMCServiceDesk__ManufacturerName__c == null || ci.BMCServiceDesk__Model__c == null || ci.BMCServiceDesk__SerialNumber__c == null || ci.BMCServiceDesk__CITag__c == null || classsel == '--None--'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please fill values in all the Required fields.'));
        }
        //Create Query to Validate
        else{
            String queryStr ='';
        
            if(ci.name != null || ci.BMCServiceDesk__CITag__c != null || ci.BMCServiceDesk__SerialNumber__c != null){
                queryStr = 'SELECT name,BMCServiceDesk__ManufacturerName__c, BMCServiceDesk__ClassName__c, BMCServiceDesk__Model__c, BMCServiceDesk__SerialNumber__c,BMCServiceDesk__CITag__c,BMCServiceDesk__PrimaryClient__c from BMCServiceDesk__BMC_BaseElement__c WHERE ';
                
                if(ci.name != null){
                    queryStr = queryStr+' name = ' + '\'' + String.escapeSingleQuotes(String.valueOf(ci.name))+ '\'';
                }
                
                if(ci.BMCServiceDesk__SerialNumber__c != null){
                    queryStr = queryStr+'OR BMCServiceDesk__SerialNumber__c = ' + '\'' + String.escapeSingleQuotes(String.valueOf(ci.BMCServiceDesk__SerialNumber__c))+ '\'';
                }
                
                if(ci.BMCServiceDesk__CITag__c != null){
                    queryStr = queryStr+'OR BMCServiceDesk__CITag__c = ' + '\'' + String.escapeSingleQuotes(String.valueOf(ci.BMCServiceDesk__CITag__c))+ '\'';
                }
                
            //Execute Query to retrieve duplicates
            ListConflictCI = Database.query(queryStr);
            }
            
            //If Duplicates are present.
            if(ListConflictCI.size()>0){
            
                //Show warning
                flagConflict = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'<html><b><font color="red">Duplicates were detedcted during Validations.<br/>Kindly review and modify values in order to continue creating new record.</font></b></html>'));
                
                //Initialize conflict sets
                Set<String> snoSet = new Set<String>();
                Set<String> acoSet = new Set<String>();
                nameSet = new Set<String>();
                
                //Put conflicts in set
                for(BMCServiceDesk__BMC_BaseElement__c conCi : ListConflictCI){
                    if(conCi.name != null)
                        nameSet.add(String.valueof(conCi.name).toLowerCase());
                    if(conCi.BMCServiceDesk__SerialNumber__c != null)
                        snoSet.add(String.valueof(conCi.BMCServiceDesk__SerialNumber__c).toLowerCase());
                    if(conCi.BMCServiceDesk__CITag__c != null)
                        acoSet.add(String.valueof(conCi.BMCServiceDesk__CITag__c).toLowerCase());
                }
                
                //If conflict in name, flag name
                if(ci.name != null){
                    if(nameSet.contains(String.valueof(ci.name).toLowerCase())){
                        conflictname = true;
                    }
                }
                
                //If conflict in Serial Number, flag Serial Number
                if(ci.BMCServiceDesk__SerialNumber__c != null){
                    if(snoSet.contains(String.valueof(ci.BMCServiceDesk__SerialNumber__c).toLowerCase())){
                        conflictSno = true;
                    }
                }
                
                //If conflict in Asset Tag, flag Asset Tag
                if(ci.BMCServiceDesk__CITag__c != null){
                    if(acoSet.contains(String.valueof(ci.BMCServiceDesk__CITag__c).toLowerCase())){
                        conflictAsset = true;
                    }
                }
            
            }
            //If no conflicts
            else{
                preview = true;
                flagConflict = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'<html><b><font color="green">Validation Successful!</font></b></html>'));
            }
        }
        return null;  
    }
    
    
    //Method to create a new Configuration Item.
    Public pagereference createCI(){
    try{
        flag = true;
        ci.BMCServiceDesk__Name__c =ci.name;
        ci.BMCServiceDesk__CMDB_Class__c = classSel;
        insert ci;
        //flag=false;
        created = true;
        preview = false;
        flagConflict = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'<html><script>setTimeout(function(){alert("Record Created Successfully!");}, 100);</script><b><font color="green">'+'\''+ci.name+'\''+' created successfully.</font></b></html>'));
    }
    catch(exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getmessage()));
    }
    return null;
    }
    
    //Method to refresh the values in "Create Configuration Item" Tab
    Public pagereference createNew(){
        ci = new BMCServiceDesk__BMC_BaseElement__c();
        created = false;
        flag = false;
        flagConflict = false;
        preview = false;
        return null;
    }
    
    //Method to show all filters
    Public pagereference showfilters(){
        showFilters = true;  
        return null;  
    } 
    
    //Method to navigate user to validation screen
    Public pagereference reValidateScreen(){
        created = false;
        flag = false;
        flagConflict = false;
        preview = false;
        return null;
    }
    
    //Method to delete a CI
    Public void removeCI()
    {
        rowNum = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        
        try{
            delete SearchList[rowNum];
            SearchList.remove(rowNum);
            searchResults = 'BASE ELEMENTS ['+String.valueOf(SearchList.size())+']';
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getmessage()));
        }
    }

}