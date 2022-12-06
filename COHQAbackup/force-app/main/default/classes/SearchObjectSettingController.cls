/*********************************************************************************
 * @File Name.............:: SearchObjectSettingController
 * @Author................:: Sanjay Singh
 * @FileType..............:: Apex Class
 * @Description...........:: Controller class for visualforce page - SearchObjectSetting
 * ********************************************************************************
 * Version................:: 1.0
 * *******************************************************************************/
public with sharing class SearchObjectSettingController {
    /***** variable Declaration Start*****************/
    public string selectedObject {get; set;}
    public List<selectOption> availableFields {get; set;}
    public List<selectOption> selectedFields  {get; set;}
    public List<selectOption> availableFilterField {get;set;}
    public List<SelectOption> selectedFilterField {get;set;}
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public Search_Object__c searchObj;
    public List<SelectOption> alreadySelectedObject {get;set;}
    public Boolean reOrderFlag {get; set;}
    public String OptionsHidden {get; 
                                 set {      
                                       OptionsHidden = value;       
                                       setOptions(alreadySelectedObject, value);        
                                 }      
    }
    /***** variable Declaration End*****************/
    
    /***** Constructor*****************/
    public SearchObjectSettingController(){
        // Initialize Variables
        availableFields = new List<selectOption>();
        selectedFields =  new List<selectOption>();
        availableFilterField = new List<selectOption>();
        selectedFilterField  = new List<selectOption>();
        reOrderFlag = false;        
        fetchSearchObject();
    }
    
    // converts datatable in to reorderable selectlist 
    public void editForRearrange(){         
        reOrderFlag = true;     
    }   
    // On clicking save order system should update the order of search object records
    public void reArrangeOrder(){       
        reOrderFlag = false;        
        if(!alreadySelectedObject.isEmpty()){       
            Integer count = 0;      
            List<Search_Object__c> sObjToUpdate = new List<Search_Object__c>();     
            for(SelectOption selOp: alreadySelectedObject){     
                Search_Object__c obj = new Search_Object__c(id=selOp.getValue(), order__c= decimal.valueOf(count));     
                sObjToUpdate.add(obj);      
                count++;        
            }       
            try{        
                if(!sObjToUpdate.isEmpty()){        
                    update sObjToUpdate;        
                }       
                reOrderFlag = false;        
                fetchSearchObject();        
            }catch(Exception e){        
                apexpages.addMessages(e);       
                reOrderFlag = true;     
            }       
        }       
    }   
    //Query All availale search Objects order by order field
    public void fetchSearchObject(){        
        alreadySelectedObject = new List<selectOption>();       
        For(Search_Object__c sobj : [Select id, Name from Search_Object__c order by Order__c ASC NULLS LAST]){      
            alreadySelectedObject.add(new selectOption(sobj.id, sobj.Name));        
        }       
    }       
            
    // Parse &-separated values and labels from value and       
    // put them in option       
    private void setOptions(SelectOption[] options, String value) {     
        options.clear();        
        String[] parts = value.split('&');      
        for (Integer i=0; i<parts.size()/2; i++) {      
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'),       
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));        
        }       
    }       
    
    // Return Object List for showing as picklist in vf page
    public List<SelectOption> getObjectNames(){
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        objNames.add(new SelectOption('Select','--Select--')); 
        
        // Abhisheks code to show only required objects in the list
        for(String objname : entities){
            if(objname.equalsIgnoreCase('User') || objname.equalsIgnoreCase('Department__c') || 
               objname.equalsIgnoreCase('Department_Components__c') ||objname.equalsIgnoreCase('Secondary_Department__c') ||
               objname.equalsIgnoreCase('ContentVersion') || objname.equalsIgnoreCase('COH_SI_NewsandAnnouncement__c') ||
              objname.equalsIgnoreCase('Document') 
               || objname.equalsIgnoreCase('knowledge__kav') // changes by Sanjay on 10-20-2021
              )
            {
                Schema.DescribeSObjectResult sobj = schemaMap.get(objname).getDescribe();
                objNames.add(new SelectOption(sobj.getName(),sobj.getLabel()));
            }
        }
        return objNames;
     }
    // populate search fields and filterFields which are already selected 
    // on select of object in picklist
    public void populateFields(){
        availableFields = new List<selectOption>();
        selectedFields =  new List<selectOption>();
        availableFilterField = new List<selectOption>();
        selectedFilterField  = new List<selectOption>();
        system.debug('====='+selectedObject);
        if(selectedObject != 'Select'){
            List<Search_Object__c> objList =  new List<Search_Object__c>([Select Id, Name, Object_API_Name__c from Search_Object__c where Object_API_Name__c=: selectedObject]);
            if(!objList.isEmpty()){
                searchObj = objList[0];
            }else{
                searchObj = null;
            }
            findObjectFields();    
        }
            
    }
     
    public void findObjectFields() {
         Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         selectedFields =  new List<selectOption>();
         Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
         Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
         Set<string> fieldNameSet = new  Set<string>();
         Set<String> filterFieldNameSet = new Set<string>();
         
         
         if(searchObj != null){
             for(Search_Field__c f: [Select id, Name,Field_API_Name__c, Search_Object__c, order__c from Search_Field__c  where Search_Object__c =:searchObj.id 
                                           and Field_API_Name__c != null order by order__c ASC]){
                 selectedFields.add(new SelectOption(f.Field_API_Name__c , f.Name));
                 fieldNameSet.add(f.Field_API_Name__c);                              
             }
             
             for(Filter_Field__c f: [Select Id, Name, Field_API_Name__c,Search_Object__c, order__c From Filter_Field__c Where 
                                     Search_Object__c =:searchObj.id and Field_API_Name__c != null order by Order__c ASC]){
                 selectedFilterField.add(new SelectOption(f.Field_API_Name__c, f.Name));
                 filterFieldNameSet.add(f.Field_API_Name__c);                        
             }
         }
        
         for (String fieldName: fieldMap.keySet()) {  
             
             Schema.DescribeFieldResult df = fieldMap.get(fieldName).getDescribe();
             system.debug('===fieldMap=='+df);
             if(!fieldNameSet.contains(fieldName)){
                availableFields.add(new SelectOption(df.getName(), df.getLabel()));
             }
             if(!filterFieldNameSet.contains(fieldName)){
                 availableFilterField.add(new SelectOption(df.getName(), df.getLabel()));
             }
             //fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
         }
      
         
      }
    //Save Fields selected.
    //If object selected firstTime insert searchObject , filter and selcted search Field otherwise update it.
    //If all fields are being removed then remove search object too.
    public void doSave(){
        if(string.isBlank(selectedObject) || selectedObject =='Select' ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Select Object.'));
            return;
        }
        /*if(selectedFields.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Select at least one field.'));
            return;
        }*/
        if(searchObj == null){
            
            string objName = schemaMap.get(selectedObject.toLowerCase()).getDescribe().getName();
            
            searchObj  = new Search_Object__c(Name=objName, Object_API_Name__c=selectedObject);
        } 
        try{
            upsert searchObj;
            Map<string, Search_Field__c> fieldMap = new Map<string,Search_Field__c>();
            Map<string, Filter_Field__c> FilterfieldMap = new Map<string,Filter_Field__c>();
            for(Search_Field__c sf: [Select id, Name,Field_API_Name__c, Search_Object__c,Order__c from Search_Field__c  where Search_Object__c =:searchObj.id 
                                           and Field_API_Name__c != null order by Order__c ASC]){
                fieldMap.put(sf.Field_API_Name__c, sf) ;
            }
            
            for(Filter_Field__c ff: [Select id, Name,Field_API_Name__c, Search_Object__c,Order__c from Filter_Field__c  where Search_Object__c =:searchObj.id 
                                           and Field_API_Name__c != null order by Order__c ASC]){
                FilterfieldMap.put(ff.Field_API_Name__c, ff) ;
            }
            
            List<Search_Field__c> newFieldsToupsert = new List<Search_Field__c>();
            List<Search_Field__c> FieldsToDelete = new List<Search_Field__c>();
            Set<string> selFSet = new Set<string>();
            Integer order = 0;
            List<Filter_Field__c> filterFieldsToupsert = new List<Filter_Field__c>();
            List<Filter_Field__c> filterFieldsToDelete = new List<Filter_Field__c>();
            Set<string> selFilterFSet = new Set<string>();
            Integer filterOrder = 0;
            
            for(SelectOption s : selectedFields){
                
                selFSet.add(s.getValue());
                if(fieldMap.isEmpty() || (!fieldMap.isEmpty() && !fieldMap.containsKey(s.getValue())) ){
                
                   /*
                      * Start Sanjay :: 01-07-2016
    `                 * To show column header as Departments, More information we added below logic 
                      * */
                    string fieldName = s.getLabel(); 
                    if(selectedObject.equalsIgnoreCase('Secondary_Department__c') && s.getValue().equalsIgnoreCase('Secondary_Department_Content__c')){
                       fieldName = 'Departments, More Information' ;
                    }
                    /***************************************************************/
                     Search_Field__c sf = new Search_Field__c(Name=s.getLabel(), 
                                                              Field_API_Name__c = s.getValue(),
                                                              order__c = order,
                                                              Search_Object__c = searchObj.id);
                     newFieldsToupsert.add(sf);
                }else if(!fieldMap.isEmpty() && fieldMap.containsKey(s.getValue())){
                    Search_Field__c sf = fieldMap.get(s.getValue());
                    sf.Order__c = order;
                    newFieldsToupsert.add(sf);
                } 
                order++;
            }
            for(SelectOption s : selectedFilterField){
                
                selFilterFSet.add(s.getValue());
                if(FilterfieldMap.isEmpty() || (!FilterfieldMap.isEmpty() && !FilterfieldMap.containsKey(s.getValue())) ){
                     Filter_Field__c sf = new Filter_Field__c(Name=s.getLabel(), 
                                                              Field_API_Name__c = s.getValue(),
                                                              order__c = filterOrder,
                                                              Search_Object__c = searchObj.id);
                     filterFieldsToupsert.add(sf);
                }else if(!FilterfieldMap.isEmpty() && FilterfieldMap.containsKey(s.getValue())){
                    Filter_Field__c sf = FilterfieldMap.get(s.getValue());
                    sf.Order__c = filterOrder;
                    filterFieldsToupsert.add(sf);
                } 
                filterOrder++;
            }
            
            if(!fieldMap.isEmpty()){
                for(String s: fieldMap.keySet()){
                    if(!selFSet.contains(s)){
                        FieldsToDelete.add(fieldMap.get(s));
                    }
                }  
            }
            
            if(!FilterfieldMap.isEmpty()){
                for(String s: FilterfieldMap.keySet()){
                    if(!selFilterFSet.contains(s)){
                        filterFieldsToDelete.add(FilterfieldMap.get(s));
                    }
                }  
            }
            
            if(!newFieldsToupsert.isEmpty()){
                upsert newFieldsToupsert;
            }
            
            if(!filterFieldsToupsert.isEmpty()){
                upsert filterFieldsToupsert;
            }
            if(!FieldsToDelete.isEmpty()){
                delete FieldsToDelete;
            }
            if(!filterFieldsToDelete.isEmpty()){
                delete filterFieldsToDelete;
            }
            if(newFieldsToupsert.isEmpty()){
                delete searchObj;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.confirm,'Object and fields saved successfully'));
        }catch(Exception e){
            String error = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.warning, error));
            return;
        }
    }
}