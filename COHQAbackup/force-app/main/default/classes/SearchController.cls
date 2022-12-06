/***********************************************************************************
 * @File Name.............:: SearchController
 * @Author................:: Sanjay Singh
 * @FileType..............:: Apex Class
 * @Description...........:: Controller class for visualforce page - Search
 * *********************************************************************************
 * Version................:: 1.0
 * ********************************************************************************/
public without sharing class SearchController {
    /**** Varible Declaration Start*************/
    public string keyword {get;set;}
    public Account acc {get; set;}
    public string filterString {get; set;}
    public List<fieldWrapper> filterList {get; set;}
    public List<ContentWrapper> fileTypeList {get;set;}
    public string departmentKeyPrefix {get; set;} 
    public string secDepKeyPrefix {get; set;}
    public string depAccordion {get; set;}
    public string contentTypeStr {get; set;}
    public string fileTypeStr {get; set;}
    public string scopeTypeStr {get; set;}
    public List<ContentWrapper>  contentTypeList {get; set;}
    public List<ContentWrapper> scopeTypeList {get;set;}
    public string newsStr {get; set;}
    public string WhomSuppWhom {get;set;}
    public string INSIDE_HOPE_DOMAIN {get;set;}
    /** Added Licence Check By Sanjay :: 01-31-2017***/
    public static final Set<string> licenseSet = new Set<String>{'Salesforce', 'Salesforce Platform'};
    
    /** Added by Sanjay date 12-17-15
        set to contain lists of specific file format to search in content version  
    ***/
    private final set<string> fileFormatSet = new Set<String>{'docx', 'pptx', 'doc', 'txt', 'xlsx','xls','pdf'};
    /**** Varible Declaration End*************/
    
    /**** Constructor*************************/
    public SearchController(){
        INSIDE_HOPE_DOMAIN = Label.INSIDE_HOPE_DOMAIN;
        acc=  new Account();
        keyword = apexpages.currentPage().getparameters().get('keyword');
        filterList = getAllFilters();
        fileTypeList = getDocTypes();
        contentTypeList = queryRecordTypeOnContent();
        scopeTypeList = fetchScopePickListValue();
        /****** Get Key Prefix dynamically for speciific objects***********/
        departmentKeyPrefix = Department__c.sObjectType.getDescribe().getKeyprefix();
        secDepKeyPrefix = Secondary_Department__c.sObjectType.getDescribe().getKeyprefix();
        depAccordion = Department_Components__c.sObjectType.getDescribe().getKeyprefix();
        newsStr = COH_SI_NewsandAnnouncement__c.sObjectType.getDescribe().getKeyprefix();
        
        /* Sanjay 01/26 */
        
        //WhomSuppWhom = Supported_By__c.sObjectType.getDescribe().getKeyprefix();
        
        /********************************************************************/    
    }
    
    public List<ContentWrapper> fetchScopePickListValue(){
        List<ContentWrapper> scopeList = new List<ContentWrapper>();
        Schema.DescribeFieldResult fieldResult =ContentVersion.Scope__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            ContentWrapper cw = new ContentWrapper();
            cw.scopePicklistEntry = f.getValue();
            scopeList.add(cw);   
        }       
        return scopeList;
    }
    
    /**
     *@Description :: Return wrapper List of content type record to show 
     *                on vf page with checkbox
     */
    public List<ContentWrapper> queryRecordTypeOnContent(){
        List<ContentWrapper> conTList = new List<ContentWrapper>();
        for(RecordType rt : [Select id, name from RecordType where sObjectType='ContentVersion']){
            ContentWrapper ct = new ContentWrapper();
            ct.recTypeName = rt.Name;
            ct.recTypeId = rt.Id;
            conTList.add(ct);
        }
        return conTList; 
    }
    
    /**
     *@Description :: Return wrapper List of availabel document types based on records to show 
     *                on vf page with checkbox
     */
     
     /* Start Sanjay Singh Dec 7th 2015 Commenting the code to add ContentVersion for Software App*/
    
    /*
    public List<ContentWrapper> getDocTypes(){
        List<ContentWrapper> conTList = new List<ContentWrapper>();
        for(AggregateResult ag : [Select count(id) counter , Type from Document group by Type ]){
            ContentWrapper ct = new ContentWrapper();
            system.debug('-=====ag===='+ag);
            ct.fileType = String.valueOf(ag.get('Type'));
            ct.fileCount = Integer.valueOf(ag.get('counter')); 
            conTList.add(ct);
        }
        return conTList;
    }
    */
    
    /*End Sanjay Singh Dec 7th 2015 Commenting the above code to add ContentVersion for Software App */
    
    
    /*Start Sanjay Singh Dec 7th 2015 Added code for Software app*/
    
    public List<ContentWrapper> getDocTypes(){
        List<ContentWrapper> conTList = new List<ContentWrapper>();
        /** Added fileFormatSet check ....by Sanjay date 12-17-15
            search selected formats only
        */
        for(AggregateResult ag : [Select count(id) counter , FileExtension from ContentVersion where FileExtension in :fileFormatSet 
                    group by FileExtension ]){
            ContentWrapper ct = new ContentWrapper();
            system.debug('-=====ag===='+ag);
            ct.fileType = String.valueOf(ag.get('FileExtension'));
            ct.fileCount = Integer.valueOf(ag.get('counter')); 
            conTList.add(ct);
        }
        return conTList;
    }
    
    /*End Sanjay Singh Dec 7th 2015 for Software app*/
    
      
    
    
    /**
     *@Description :: Query Filter fields for search Objects
     */
    public List<fieldWrapper> getAllFilters(){
        List<fieldWrapper> fs =  new List<fieldWrapper>();
        for(Filter_Field__c f : [Select Id, Name, Search_object__c,Search_object__r.Name,Search_object__r.Object_API_Name__c, field_API_Name__c from Filter_Field__c  
                                 order by Search_object__r.Name ASC]){
                 SObject s = Schema.getGlobalDescribe().get(f.Search_object__r.Object_API_Name__c).newSObject() ; 
                 fieldWrapper fw = new fieldWrapper(f,s);
                 fs.add(fw);                    
        }
        return fs;
        
    }
    
    /**
     *@Description :: method get called from vf page when user clicks apply filter button.
     *                It is creating string for filter which will send in to remote action as parameter from 
     *                vf Page.
     */
    public pageReference createFilterStr(){
        system.debug('===filterList====='+filterList);
        filterString = '';
        String s = '';
        scopeTypeStr = '';
        for(fieldWrapper f : filterList){
            system.debug('======field======'+f);
            system.debug('======fieldObj======'+f.obj.get(f.field.Field_API_Name__c));
            if(f.obj.get(f.field.Field_API_Name__c) != null && f.obj.get(f.field.Field_API_Name__c) != '' ){
                s += ';'+f.field.Search_object__r.Object_API_Name__c +':'+f.field.Field_API_Name__c + ':'+ f.obj.get(f.field.Field_API_Name__c);    
            }
        }
        contentTypeStr = '';
        
        for(ContentWrapper cw : contentTypeList){
            if(cw.isSelect){
                contentTypeStr += '-'+cw.recTypeId ;
            }
        }
        
        if(contentTypeStr != ''){
            contentTypeStr = contentTypeStr.substring(1);
        }
        
        fileTypeStr = '';
        for(ContentWrapper cw : fileTypeList){
            if(cw.isSelect){
                fileTypeStr += '-'+cw.fileType ;
            }
        }
        if(fileTypeStr != ''){
            fileTypeStr = fileTypeStr.substring(1);
        }
        
        for(ContentWrapper cw : scopeTypeList){
            if(cw.isSelect){
                scopeTypeStr += ';'+ cw.scopePicklistEntry;
            }
        }
        if(scopeTypeStr != ''){
            scopeTypeStr = scopeTypeStr.substring(1);
        }       
        if(s != '')
            s =s.substring(1);
        filterString = s;
        return null;
    }
    
    /**
     *@Description :: method creates query string for any object. It sets which field to return and where conditions.
     */
    private static string createInnerFieldString(Map<string, Search_Object__c> searchObjMap, string objName,
                                                 Map<string, Map<String, String>> filterFieldMap, string otherStr){  
        string fieldStr = '';
        system.debug('================otherStr==='+otherStr);                       
        system.debug(objName+'==searchObjMap=='+searchObjMap);                                             
        if(searchObjMap.containsKey(objName)){
            system.debug('==contains=='+searchObjMap.get(objName).Search_Fields__r);
            for(Search_Field__c sf : searchObjMap.get(objName).Search_Fields__r){
                if(fieldStr != '')
                    fieldStr += ', ';
                fieldStr += sf.Field_API_Name__c ;   
                
            } 
        }else{
            if(objName == 'user' || objName == 'contact') {
                fieldStr += ' FirstName , LastName ';                
            }else if(!objName.equalsIgnoreCase('contentVersion')){
                fieldStr += ' Name ';     
            }
        }
        /** 
        commented by Sanjay Singh Date 12-12-2015    
        Added below code for adding department field for department accordion object
        Check if Department field is not getting queried then add it to query.    
        **************************************************************************
        changes made by sanjay Date 12-22-2015
        Added image_url field for news and announcement object
        query this field in any case no matter ..user have added it in search fields or not
        same as department name field on department component object
        */                                            
        if(objName == 'department_components__c' || Objname.equalsIgnoreCase('coh_si_newsandannouncement__c')){
            //|| Objname.equalsIgnoreCase('Supported_By__c') ){
            If(fieldStr != ''){
                Set<string> fieldSet = new Set<string>();
                for(string fs : fieldStr.split(',')){
                    fs = fs.trim();
                    fieldSet.add(fs);
                }
                if(Objname.equalsIgnoreCase('department_components__c')){
                    if(!fieldSet.contains('Department_Name__c')){
                        fieldStr += ', Department_Name__c ';
                    }    
                }else if(Objname.equalsIgnoreCase('coh_si_newsandannouncement__c')){
                    if(!fieldSet.contains('Image_URL__c')){
                        fieldStr += ', Image_URL__c ';
                    }
                }/*else if(Objname.equalsIgnoreCase('Supported_By__c')){
                    if(!fieldSet.contains('Supported_User__c')){
                        fieldStr += ', Supported_User__c ';
                    }
                }*/
            }else{
                if(Objname.equalsIgnoreCase('department_components__c')){
                    fieldStr += ' Department_Name__c ';
                }else if(Objname.equalsIgnoreCase('coh_si_newsandannouncement__c')){
                    fieldStr += ' Image_URL__c ';
                }/*else if(Objname.equalsIgnoreCase('Supported_By__c')){
                    fieldStr += ' Supported_User__c ';
                }*/    
            }                                                 
        }                                             
        /****************************************/                                             
        if(fieldStr != ''){
            if(searchObjMap.containsKey(objName) && filterFieldMap.containsKey(searchObjMap.get(objName).Object_API_Name__c)){
                string whereStr = '';
                for(string s : filterFieldMap.get(searchObjMap.get(objName).Object_API_Name__c).KeySet()){
                    whereStr += ' AND '+ s +'=\''+string.escapeSingleQuotes(filterFieldMap.get(searchObjMap.get(objName).Object_API_Name__c).get(s))+'\' ';
                }
                if(whereStr != ''){
                    whereStr = whereStr.substring(5);
                    fieldStr += ' Where '+ whereStr;
                }
           }
           if(!string.isBlank(otherStr))
                fieldStr += ' '+ otherStr ;
           fieldStr = '( '+ fieldStr +' ) ';
        }                                            
           
        system.debug('===fieldStr===='+fieldStr);                                             
        return fieldStr;
    }
    
    /**
     *@Description :: This method get called from vf page by javascript and returns search result based on parameters.
     */
    @remoteAction
    public static List<Wrapper> searchKeyWord(string keyword, string filterString, 
                                              String conTypeStr,String fileType,
                                              string scopeType,
            boolean peronFullnameFlag, boolean departmentFlag, boolean docLibFlag, boolean docTypFlag, 
            boolean softTypeFlag, boolean docPolicyFlag, boolean depPageFlag, boolean newsFlag){
        
        List<Wrapper> tempList = new List<Wrapper>();
        // List to contain selected content Version record Type
        List<string> conTypeStrList = new List<string>();
        // List to contain selected File Type
        List<string> fileTypeStrList = new List<string>();        
        // Escape single quote to handle SOSL-Enjection 
        keyword = String.escapeSingleQuotes(keyword);
        // Search query        
        String searchQuery = 'FIND \'' +keyword+'*\' IN ALL FIELDS RETURNING ';
        string sObjStr = '';
        List<string> objName = new List<string>();
        Map<string, Map<String, String>> filterFieldMap = new Map<string, Map<String, String>>();
                
        if(filterString != null && filterString != ''){
            for(String s : filterString.split(';')){
               List<string> inners = s.split(':');
               if(inners.size() == 3){
                   if(!filterFieldMap.containsKey(inners[0])){
                       filterFieldMap.put(inners[0], new Map<string, String>());
                   }
                   filterFieldMap.get(inners[0]).put(inners[1],inners[2]);
               } 
            }
        }
        
        if(conTypeStr != null && conTypeStr != ''){
            conTypeStrList = conTypeStr.split('-');
        }
                
        if(fileType != null && fileType != ''){
            fileTypeStrList  = fileType.split('-');     
        }        
        // Map to maintain searh field list Object name wise  
        map<String, List<Search_Field__c>> sfmap = new map<String, List<Search_Field__c>>();
        
        Map<string, Search_Object__c> searchObjMap = new Map<string, Search_Object__c>();
        // Query Search Object Order Wise ---         
        List<Search_Object__c> searchObjList = new List<Search_Object__c>([Select id, Name, Object_API_Name__c, 
                                                                           (Select Id, Name, Order__c, Field_API_Name__c 
                                                From Search_Fields__r order by Order__c ASC NULLS LAST) 
                                           From Search_Object__c order By Order__c ASC NULLS LAST  Limit 100]);
                
        for(Search_Object__c sObj : searchObjList ){
            
            if(!string.isBlank(sObj.Object_API_Name__c)){
                searchObjMap.put(sObj.Object_API_Name__c.toLowerCase(), sObj );
            }
        }
        
        If(searchObjMap.isEmpty()){
            return tempList;
        }
                string knowledgeExtraQuery;
        /*****
         * peronFullnameFlag : If checked search and return user where full name mataches.
         * departmentFlag    : If Checked search and return user where department matches with keyword.
         * docLibFlag        : If checked search and return content version records matched to keyword.
         * docTypFlag        : If checked search and return content version record based on selected recordType 
         * softTypeFlag      : If checked search and return documents based on selected Type checkbox 
         * depPageFlag       : If checked search and return In department, contact , user ,Department accordion and 
         *                     Secondary Department object where keyword matches.
         * newsFlag          : If checkd  search and return news andannouncement record where keyword matches.
         * **/        
         
         /*
          * Changes made by Sanjay :: 
          * Date 12-25-2015
          * Added search object check:: If object is not in search obect custom object then it will not seaerch in that object
          * Note:: Check object api name with lower case becase searchObject map keys are in lower case 
         */
        if(peronFullnameFlag || departmentFlag ||  docLibFlag || docTypFlag || softTypeFlag || docPolicyFlag || depPageFlag || newsFlag){
            // Write Logic
            //added searchobject Check 
            if((peronFullnameFlag || depPageFlag || departmentFlag) && searchObjMap.containsKey('user')){
                objName.add('User');
                //added mainwhrstr  date- 05/25/2016
                /** Added Licence Check By Sanjay :: 01-31-2017 ***/
                string mainWhrStr = ' Where IsActive = true AND Hide_in_Search__c = False AND Salesforce_Licence_Type__c IN: licenseSet';
                string whrStr = '';
                if(peronFullnameFlag){
                    // Code by Abhishek to fix SFIP-127 
                    // Added Open Bracket
                   //whrStr = ' Where IsActive = true AND ( Name like \'%'+ keyword+'%\' ' ;
                     whrStr = '  AND ( Name like \'%'+ keyword+'%\' ' ;
                                      
                    //Previous code by Sanjay before the fix for SFIP-127
                   // whrStr = ' Where Name like \'%'+ keyword+'%\' ' ;  
                }
                
                if(departmentFlag){
                    if(whrStr == ''){ // Added by sanjay Date 03/16/2016- Added isActive Check
                        //added hide in search check Date 05/25/2016
                        whrStr += ' AND Department like \'%'+ keyword+'%\' ' ; 
                    }else{
                        whrStr += ' OR Department like \'%'+ keyword+'%\' )' ; // Added by sanjay Date 03/16/2016- Added close bracket
                    }
                    //Added by sanjay-- date 03/16/2016 Added else condition
                }else{
                    if(whrStr != ''){
                        whrStr += ' ) ';
                    }
                }
                mainWhrStr += whrStr +' order by Name ASC ';
                sObjStr +=  ' User '+ createInnerFieldString(searchObjMap, 'user',filterFieldMap, mainWhrStr); 
                system.debug('object search string' + sObjStr);         
            }
            
            if(depPageFlag ){
                /*End Added from Intranetdv org*/
                //added searchobject Check , create temp Inner string
                string tempSearchStr = '';
                if(searchObjMap.containsKey('contact')){
                    objName.add('Contact');
                    if(tempSearchStr != '') tempSearchStr += ',';
                    tempSearchStr +=  ' Contact '+ createInnerFieldString(searchObjMap, 'contact',filterFieldMap, '') ;
                }
                if(searchObjMap.containsKey('department__c')){
                    objName.add('Department__c');
                    if(tempSearchStr != '') tempSearchStr += ',';
                    tempSearchStr +=  ' Department__c  '+ createInnerFieldString(searchObjMap, 'department__c',filterFieldMap, '');
                }
                if(searchObjMap.containsKey('department_components__c')){
                    objName.add('Department_Components__c');
                    if(tempSearchStr != '') tempSearchStr += ',';
                    tempSearchStr += ' Department_Components__c '+createInnerFieldString(searchObjMap, 'department_components__c',filterFieldMap, '');
                }
                if(searchObjMap.containsKey('secondary_department__c')){
                    objName.add('Secondary_Department__c');
                    if(tempSearchStr != '') tempSearchStr += ',';
                    tempSearchStr +=  ' Secondary_Department__c '+ createInnerFieldString(searchObjMap, 'secondary_department__c',filterFieldMap, '') ; 
                }
                
                if(tempSearchStr != ''){
                    if(sObjStr != '') sObjStr += ',';
                    sObjStr += tempSearchStr;
                }
            }
            //added searchobject Check 
            if((docLibFlag || docTypFlag || docPolicyFlag  || softTypeFlag) && searchObjMap.containsKey('contentversion')){
                if(sObjStr != '') sObjStr += ',';
                string whrSTr = ' Where Do_not_Include_in_Search__c = False ';
                if(!conTypeStrList.isEmpty()){
                    whrSTr = ' where RecordTypeId IN: conTypeStrList and Do_not_Include_in_Search__c = False  ' ;
                }

                if (softTypeFlag && !fileTypeStrList.isEmpty() ){
                    if(whrSTr != ''){
                        whrSTr += ' AND ';
                    }else{
                       whrSTr += ' WHERE ' ;
                    }
                    whrStr = ' Where FileExtension in : fileTypeStrList and Do_not_Include_in_Search__c = False ';
                }

                if(docPolicyFlag && !string.isBlank(scopeType)){
                    if(whrSTr != ''){
                        whrSTr += ' AND ';
                    }else{
                       whrSTr += ' WHERE ' ;
                    }
                    scopeType = string.escapeSingleQuotes(scopeType);
                    whrSTr += ' Scope__c Includes (:scopeType) ' ;  
                }
                system.debug('===conTypeStrList==='+conTypeStrList + '==='+conTypeStrList.size());
                sObjStr +=  ' ContentVersion '+ createInnerFieldString(searchObjMap, 'contentversion',filterFieldMap,whrSTr);
                objName.add('ContentVersion');
            }
            
            /* Start Sanjay  Singh date 12/09/2015 
            if(softTypeFlag){
                string whrStr = '';
                if(softTypeFlag && !fileTypeStrList.isEmpty() ){
                    / * Sanjay Singh Dec 7th whrStr = ' Where Type in : fileTypeStrList ';* /
                    whrStr = ' Where FileExtension in : fileTypeStrList ';
                    
                }
                
                if(sObjStr != '') sObjStr += ',';
               / * Sanjay Singh Dec 7th sObjStr +=  ' Document '+ createInnerFieldString(searchObjMap, 'document',filterFieldMap, ''); * /
               / * Sanjay Singh Dec 7th objName.add('Document'); * /
               
                 sObjStr +=  ' ContentVersion '+ createInnerFieldString(searchObjMap, 'ContentVersion',filterFieldMap, ''); 
                 objName.add('ContentVersion');                
            }
            Comment end   */
            //added searchobject Check 
            if(newsFlag && searchObjMap.containsKey('coh_si_newsandannouncement__c')){
                if(sObjStr != '') sObjStr += ',';
                /* Start Sanjay Date 12-17-2015 Added where condition only those news and announcement records should search where display is checked */
                sObjStr +=  ' COH_SI_NewsandAnnouncement__c '+ createInnerFieldString(searchObjMap, 'coh_si_newsandannouncement__c',filterFieldMap,' where Display__c = true ');
                objName.add('COH_SI_NewsandAnnouncement__c');
            }
        }
        else{
            //If none of the filter has been selected then system will search in those object which are selected by user 
            //from search Object Settion page.
            for(Search_Object__c sObj : searchObjList ){
                If(sObjStr != '')
                    sObjStr += ', ';
                objName.add(sObj.Name);                             
                sObjStr +=' '+ sObj.Object_API_Name__c ;
                string whrCondnstr = '';
                /* Start Sanjay Date 12-17-2015 In case of News and annuncement Object- Added where condition 
                    only those news and announcement records should search where display is checked 
                ---------------------------------------------------------*/
                if(sObj.Object_API_Name__c.equalsIgnoreCase('coh_si_newsandannouncement__c'))
                {
                    whrCondnstr = ' where Display__c = true ';
                }
                // Code by Abhishek to fix SFIP-127
                else if(sObj.Object_API_Name__c.equalsIgnoreCase('User'))
                {   // Added hide in serach check for user  Date - 05/25/2016
                /** Added Licence Check By Sanjay :: 01-31-2017***/
                    whrCondnstr = ' where IsActive = true  AND Hide_in_Search__c = False AND Salesforce_Licence_Type__c IN: licenseSet ';
                }
                // Added hide in serach check for user  Date - 07/27/2018
                else if(sObj.Object_API_Name__c.equalsIgnoreCase('contentversion'))
                {   
                   whrCondnstr = ' where Do_not_Include_in_Search__c = False ';
                }
                
                string fieldStr = createInnerFieldString(searchObjMap, sObj.Object_API_Name__c.toLowerCase(),filterFieldMap,whrCondnstr);
                if(sObj.Object_API_Name__c.equalsIgnoreCase('Knowledge__kav')){ // Changes done by Sanjay on 10-19-2021
                    if(!fieldStr.contains('UrlName')){
                        knowledgeExtraQuery = fieldStr.replace(')',',UrlName)');
                        knowledgeExtraQuery = sObj.Object_API_Name__c + knowledgeExtraQuery.replace(')', ' WHERE PublishStatus=\'Draft\' AND language=\'en_US\' AND WP_ID__c <> null)');
                    }else{
                        knowledgeExtraQuery = sObj.Object_API_Name__c + fieldStr.replace(')', ' WHERE PublishStatus=\'Draft\' AND language=\'en_US\' AND WP_ID__c <> null)');
                    }
                    fieldStr = fieldStr.replace(')', ' WHERE PublishStatus=\'Online\' AND language=\'en_US\' AND WP_ID__c = null)'); // Changes done by Sanjay on 10-19-2021
                } // Changes done by Sanjay on 10-19-2021
                sObjStr += fieldStr;
                sfmap.put(sObj.Name, sObj.Search_Fields__r) ;                              
            }
        }
        
        if(sObjStr != ''){
        
            //searchQuery += sObjStr;
            
            system.debug('searchquery==='+searchquery+sObjStr);            
            
            // Added code for getting object label        
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            Integer i=0;
            if(knowledgeExtraQuery <> null) {
                system.debug('searchquery==='+searchquery+knowledgeExtraQuery);            
                for(List<sObject> sObjList : search.query(searchquery+knowledgeExtraQuery)){
                    system.debug('sObjList==='+sObjList);
                    Wrapper wr = new Wrapper();
                    List<sObject> sObjListTemp = new List<sObject>();
                    for(sObject temp:sObjList) {
                        if(temp.get('Article__c') <> null && ((string)temp.get('Article__c')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        } else if(temp.get('Title') <> null && ((string)temp.get('Title')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        } else if(temp.get('overview__c') <> null && ((string)temp.get('overview__c')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        }
                    }
                    wr.sObjList =  sObjListTemp;
                    Wr.objectName = 'knowledge__kav';
                    wr.objLabel = 'Inside Hope (Wordpres Archives)';
                    if(sfmap.containsKey(Wr.objectName)){
                        wr.fieldList = sfmap.get(Wr.objectName);
                    }else if(searchObjMap.containsKey(Wr.objectName.toLowerCase())){
                        wr.fieldList = searchObjMap.get(Wr.objectName.toLowerCase()).Search_Fields__r;
                    }      
                    //wr.fieldList.add(new Search_Field__c(Name='WordPress URL',Field_API_Name__c='Wordpress_URL__c'));
                    tempList.add(wr);                                                       
                }
            }
            for(List<sObject> sObjList : search.query(searchquery+sObjStr)){
                if(sObjList.isEmpty()) continue;
               	SObject objTemp1 = sObjList.get(0);
                Wrapper wr = new Wrapper();
                wr.sObjList =  sObjList;
                Wr.objectName = string.valueOf(objTemp1.getSObjectType());//objName[i];
                //below code for getting object label 
                Schema.SObjectType sobjType = gd.get(Wr.objectName);
                if(Wr.objectName.equalsIgnoreCase('knowledge__kav')) {
                    List<sObject> sObjListTemp = new List<sObject>();
                    for(sObject temp:sObjList) {
                        if(temp.get('Article__c') <> null && ((string)temp.get('Article__c')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        } else if(temp.get('Title') <> null && ((string)temp.get('Title')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        } else if(temp.get('overview__c') <> null && ((string)temp.get('overview__c')).containsIgnoreCase(keyword)){
                            sObjListTemp.add(temp);
                        }
                    }
                    wr.sObjList =  sObjListTemp ;
                }
                // To show Object label  insted of API Name populate Objlabel
                if(sobjType != null){
                    wr.objLabel = sobjType.getDescribe().getLabel();
                }else{
                    wr.objLabel =Wr.objectName;    
                }
                if(Wr.objectName != null && Wr.objectName.equalsIgnoreCase('ContentVersion')){
                    // In case of content version Object show Document Library.
                    wr.objLabel = 'Document Library';
                }
                /** Added by Sanjay Date 12-17-2015
If object is department thn label should show as-
"Person's Department"
*/
                else if(Wr.objectName != null && Wr.objectName.equalsIgnoreCase('Department__c')) {
                    /* wr.objLabel = 'Person\'s Department'; */
                    wr.objLabel = 'Department';
                }
                /** Added by Sanjay Date 01-7-2016
If object is News and Announcement label should show as-
"News and Announcements"
*/
                else if(Wr.objectName != null && Wr.objectName.equalsIgnoreCase('coh_si_newsandannouncement__c')) {
                    wr.objLabel = 'News and Announcements';
                }
                else if(Wr.objectName != null && Wr.objectName.equalsIgnoreCase('Secondary_Department__c')) {
                    wr.objLabel = 'Departments, More Information';
                }
                else if(Wr.objectName != null && Wr.objectName.equalsIgnoreCase('knowledge__kav')) { // Changes done by Sanjay on 10-19-2021
                    wr.objLabel = 'Knowledge Article';// Changes done by Sanjay on 10-19-2021
                }// Changes done by Sanjay on 10-19-2021
                
                if(sfmap.containsKey(Wr.objectName)){
                    wr.fieldList = sfmap.get(Wr.objectName);
                }else if(searchObjMap.containsKey(Wr.objectName.toLowerCase())){
                    wr.fieldList = searchObjMap.get(Wr.objectName.toLowerCase()).Search_Fields__r;
                }
                i++;                                                       
                tempList.add(wr) ;                                                       
            }
            
        }
        return tempList ;
    }
    
    public class fieldWrapper {
        public sObject obj {get; set;}
        public Filter_Field__c field {get; set;}
        
        public fieldWrapper(Filter_Field__c f, SObject ob){
            this.obj = ob;
            this.field = f;
        }
        
    }
    /****
     * Wrapper class for binding object name , Label , Searh Fields in single Unit
     */
    public class Wrapper {
        public List<sObject> sObjList {get; set;}
        public string objectName      {get; set;}
        public List<Search_Field__c>  fieldList{get; set;}
        public string objLabel {get; set;}
        public Wrapper(){
            objectName = '';
            objLabel = '';
            sObjList = new List<sObject>();
            fieldList = new List<Search_Field__c>();
        }
        
    }
    
    /****
     * Wrapper class for showing content version recordType and file types 
     * with checkbox in filter panel
     */
    public class ContentWrapper {
        public string fileType {get; set;}
        public Integer fileCount {get; set;}
        public string recTypeName {get ; set;}
        public string recTypeId {get; set;}
        public boolean isSelect{get; set;}
        public string scopePicklistEntry {get; set;}
        public ContentWrapper(){
            this.isSelect = false;
        }
       
    }
}