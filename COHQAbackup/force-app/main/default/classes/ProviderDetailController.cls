/** 
      *@FileName    - ProviderDetailController
      *@CreatedDate - 03/22/2015
      *@Description - ControllerClass for visualforce page -"ProviderDetail"    
      **/

public with sharing class ProviderDetailController{
    /** For rendering input field and outputfield*/
    public boolean editMode                          {get; set;}
    
    /**For storing child NP/PA Records of provider */
    public list<Wrapper> nppaWrapper                 {get; set;}
    
    /** For Stiring AdminSupport child record of provider */
    public List<Wrapper> adminSupportList            {get; set;}
    
    /** For Provider availability detail Records */
    public List<Wrapper> availList                   {get; Set;}
 
    /** For Provider availability detail Records */
    public List<Wrapper> pDetaillist                 {get; Set;}
    
    /** Provider Detail object instance */
    public COH_SC_Provider_Detail__c providerDetail  {get; set;}
    
    public COH_SC_General_Note__c   gNote            {get; set;}
    /** To store selected location */
    public string selectedLocation                   {get; set;}
    
    /** contact object Instance */
    public contact conObj                            {get; set;}
    public Contact tempCon							 {get; set;}
    public String ProviderPager                      {get; set;}
    /**variable to store order of selected row from vf page */
    // for Adminn support list Row order
    public integer adminRow                          {get; set;}
    // For Availability Detail row order
    public integer availDetRow                       {get; set;}
    // for NP/PA list row order
    public integer nppaRow                           {get; set;}
    // for provider instruction list row order
    public integer instructionOrder                  {get; set;}
    
    public List<selectOption> availLocations         {get; set;}
    public boolean filteredLocation                  {get; set;}
    
    /**
      *Constructur Declaration
      */    
    public ProviderDetailController(ApexPages.StandardController controller){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        this.conObj  = (Contact)controller.getRecord();
        tempCon = new Contact();
        //when page load in starting all fields should show in non editable mode.
        editMode = false;
        filteredLocation = false;
        providerDetail = new COH_SC_Provider_Detail__c();
        gNote = new COH_SC_General_Note__c();   
        availLocations = new List<Selectoption>(); 
        
        findLocations();
        //Prepopulate data when page get loaded.
        queryDetails();
        // If mode = 'edit' then it should open in editable mode. (get URL parametres)
        string mode= apexpages.currentPage().getparameters().get('mode');
        if(mode != null && mode.equalsIgnoreCase('edit'))
            editMode = true;
    }
    
    public void findLocations(){
        availLocations = new List<Selectoption>(); 
        Set<String> locationSet = new Set<String>();
        for(AggregateResult ag : [Select count(Id) counter, COH_SC_Location__c  from COH_SC_NP_PA__c  where 
                                  COH_SC_Provider__c =:conObj.id and COH_SC_Location__c != null group by COH_SC_Location__c]){
           locationSet.add(String.valueOF(ag.get('COH_SC_Location__c')));                                       
        }
        
        for(AggregateResult ag : [Select count(Id) counter, COH_SC_Clinic_Location__c  from COH_SC_Availability_Detail__c  where 
                                  COH_SC_Provider__c =:conObj.id and COH_SC_Clinic_Location__c != null group by COH_SC_Clinic_Location__c]){
           locationSet.add(String.valueOF(ag.get('COH_SC_Clinic_Location__c')));                                       
        }
        
        if(locationSet.size() > 0){
            availLocations.add(new SelectOption('','-- Select --'));
            for(String s : locationSet){
                availLocations.add(new SelectOption(s,s));
            }
            filteredLocation = true;
        }else{
            availLocations = getLocations(); 
            filteredLocation = false;      
        }
        
    }
    
    public pageReference showAllLocation(){
        availLocations = getLocations(); 
        filteredLocation = false;   
        return null;
    }
    
    
    /**
     @Description: When edit button get clicked  then page should be changed to editable mode.All inputfields should get rendered.
     */   
    public pageReference doEdit(){
        editMode = true; 
        //selectedLocation = '';
        return  null;
    }
    
    /**
     @Description :  This method fetches the updated data - Provider's (Contact)  child objects data.
                     Child objects- NP/PA Details, Admin Support Details, Provider Details and Availability Details 
     */
    public void queryDetails(){
       // system.debug('----conObj-----'+conObj);
        if(conObj != null && conObj.id != null ){
            // Creating new instance of lists everytime this method called
            nppaWrapper = new List<Wrapper>();
            adminSupportList = new List<Wrapper>();
            availList = new List<Wrapper>();
            pDetaillist = new List<Wrapper>();
            /**
              Query current Provider's field pageEmil
              We need to extract pager no from pageEmail.
              format- pagerNo@xyz.c
              */  
            contact con = new Contact();
            con = [select id, FirstName,Additional_Language__c, LastName, Page_Email__c from Contact where id=: conobj.id];
            if(con != null){
            	tempCon =con;
            }    
            if(con != null && con.Page_Email__c != null){
                providerPager = cretePagerString(con.Page_Email__c);
            }
            List<COH_SC_General_Note__c> gnList = new List<COH_SC_General_Note__c>([Select id, name, COH_SC_provider__c,
                                                                                    COH_SC_Location__c, COH_SC_Note__c from 
                                                                                    COH_SC_General_Note__c where COH_SC_provider__c=:conObj.id 
                                                                                    and COH_SC_Location__c =: selectedLocation]);
            if(!gnList.isEmpty()){
               gNote =  gnList[0];
            }else{
                gNote = new COH_SC_General_Note__c();
            }
            
            // Query child NP/PA records.
            for(COH_SC_NP_PA__c nppa : [Select id, Name, COH_SC_Pager__c, COH_SC_Extn__c, COH_SC_Location__c, COH_SC_NP_PA__c, COH_SC_NP_PA__r.FirstName, COH_SC_NP_PA__r.LastName,  
                                        COH_SC_NP_PA__r.Page_Email__c,COH_SC_NP_PA__r.Email,COH_SC_NP_PA__r.Phone, COH_SC_Provider__c from  
                                        COH_SC_NP_PA__c where COH_SC_Provider__c =:conObj.id and COH_SC_Location__c =: selectedLocation order by createdDate ASC]){
                wrapper wp = new wrapper(nppa, nppaWrapper.size());
                wp.email = nppa.COH_SC_NP_PA__r.Email != null ? nppa.COH_SC_NP_PA__r.Email : '';
                wp.phone = nppa.COH_SC_NP_PA__r.Phone != null ? nppa.COH_SC_NP_PA__r.Phone : '';
                
                if(nppa.COH_SC_NP_PA__r.Page_Email__c != null){
                    // WE NEED TO SHOW PAGER NO IN  SPECIFIC FORMAT- "xxx-xxx-xxxx";
                    wp.Pager = cretePagerString(nppa.COH_SC_NP_PA__r.Page_Email__c);
                }
                
                nppaWrapper.add(wp);
            }
            //system.debug('----nppaWrapper-----'+nppaWrapper.size());
            
            //Query Admin Support Child Records.
            //Changes by Sanjay 16th July 2021: Adding Fax in SOQL Query
            for(COH_SC_Admin_Support__c asd : [Select id, Name, COH_SC_Pager__c, COH_SC_Admin__r.Page_Email__c, COH_SC_Ext__c, 
                                        COH_SC_Location__c, COH_SC_Admin__c,COH_SC_Admin__r.FirstName, COH_SC_Admin__r.Fax, 
                                        COH_SC_Admin__r.LastName, COH_SC_Admin__r.Email, COH_SC_Admin__r.Phone, COH_SC_Provider__c from  
                                        COH_SC_Admin_Support__c  where COH_SC_Provider__c =:conObj.id  order by createdDate ASC]){
                wrapper wp = new wrapper(asd, adminSupportList.size());
                wp.email = asd.COH_SC_Admin__r.Email != null ? asd.COH_SC_Admin__r.Email : '';
                wp.phone = asd.COH_SC_Admin__r.Phone != null ? asd.COH_SC_Admin__r.Phone : '';
                wp.fax = asd.COH_SC_Admin__r.Fax != null ? asd.COH_SC_Admin__r.Fax : ''; // Changes by Sanjay Singh on 16th July 2021
                wp.Pager = cretePagerString(asd.COH_SC_Admin__r.Page_Email__c);
                adminSupportList.add(wp);
            }
            //system.debug('----adminSupportList-----'+adminSupportList.size());
            
            //Query availability Detail Child Records.
            for(COH_SC_Availability_Detail__c avd : [SELECT Id, Name, COH_SC_Provider__c, COH_SC_Day__c, COH_SC_Start_Time_AM__c, COH_SC_End_Time_AM__c, COH_SC_Start_Time_PM__c, COH_SC_End_Time_PM__c, 
                                                    COH_SC_Provider__r.FirstName, COH_SC_Provider__r.LastName,COH_SC_Clinic_Week__c,
                                                    COH_SC_Locations__c, COH_SC_Clinic_Location__c, COH_SC_Ext__c FROM COH_SC_Availability_Detail__c where COH_SC_Provider__c =:conObj.id
                                                    and COH_SC_Clinic_Location__c =: selectedLocation order by name]){
                
                wrapper wp = new wrapper(avd, availList.size());
                availList.add(wp);
            }
            //system.debug('----availList-----'+availList.size());
            
            // Query Provider detail record from Provider detail obj
            for(COH_SC_Provider_Detail__c avd : [Select id, Name, COH_SC_Event__c,COH_SC_Duration_From__c, COH_SC_Duration_To__c,
                                                COH_SC_Location__c , COH_SC_Note__c, COH_SC_Provider__c from COH_SC_Provider_Detail__c
                                                where COH_SC_Location__c =: selectedLocation and COH_SC_Provider__c=:conObj.id order by Name ASC]){
                
                wrapper wp = new wrapper(avd, pDetaillist.size());
                pDetaillist.add(wp);
            }
        }
    }
    
    public string cretePagerString(string pageEmail){
        string pagerstr = '';
        if(pageEmail != null && pageEmail != ''){        
            string s = pageEmail.split('@')[0];
            
            if(s.length() == 10){
                pagerstr = s.substring(0,3)+'-'+s.substring(3, 6) +'-'+ s.substring(6);
            }
            else
                pagerstr = s;
                
        }    
        return pagerstr;
    }
    
    
    
    
    /**
     @Description :  To Prepopulate location picklist on vf page
                     We craetd this property.It will show all location values which are mentioned in 
                     contact's picklist field- Location
     */
    public List<SelectOption> getLocations(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select --'));
        Schema.DescribeFieldResult fieldResult = Contact.Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return options;
    }
    
    /**
     @Description :  For upserting all details 
                     On single click of save button - It will save provider detail record as well as 
                     its child objects records too.
     */
    public pageReference doSave(){
        if(conObj != null && conObj.id != null){
            if(selectedLocation != null && selectedLocation != '' ){
                try{
                    
                    if(tempCon != null){
                    	conObj.Additional_Language__c = tempCon.Additional_Language__c;	
                        update conObj;
                    }
                    
                    if(gNote != null){
                        gNote.COH_SC_Location__c = selectedLocation ;
                        if(gNote.COH_SC_Provider__c == null)
                            gNote.COH_SC_Provider__c = conObj.id;
                        
                        upsert gNote;
                        
                    }
                    
                    
                    if(pDetaillist  != null && pDetaillist.size() > 0){
                        List<COH_SC_Provider_Detail__c> providerInstructionINserts = new List<COH_SC_Provider_Detail__c>();
                        for(wrapper w : pDetaillist){
                            if(w.pdetail.coh_SC_Provider__c == null)
                                w.pdetail.coh_SC_Provider__c = conObj.id;
                            w.pdetail.COH_SC_Location__c = selectedLocation;
                            providerInstructionINserts.add(w.pdetail);
                        }
                        upsert providerInstructionINserts;
                    }
                    
                    if(nppaWrapper != null && nppaWrapper.size() > 0){
                        List<COH_SC_NP_PA__c> nppaUpsert = new List<COH_SC_NP_PA__c>();
                        for(wrapper w : nppaWrapper){
                            w.nppaObj.COH_SC_Provider__c = conobj.id;
                            w.nppaObj.COH_SC_Location__c = selectedLocation;
                            
                            nppaUpsert.add(w.nppaObj);
                        }
                        upsert nppaUpsert  ;
                        
                        system.debug('===nppaUpsert===='+nppaUpsert.size());
                    }
                    if(adminSupportList != null && adminSupportList.size() > 0){
                        List<COH_SC_Admin_Support__c> adminUpsert = new List<COH_SC_Admin_Support__c>();
                        for(wrapper w : adminSupportList){
                            w.adminSupport.COH_SC_Provider__c = conobj.id;
                            //w.adminSupport.COH_SC_Location__c = selectedLocation;
                            adminUpsert.add(w.adminSupport);
                        }
                        upsert adminUpsert  ;
                        system.debug('===adminUpsert===='+adminUpsert.size());
                    }
                    
                    if(availList != null && availList.size() > 0){
                        List<COH_SC_Availability_Detail__c> avdUpsert = new List<COH_SC_Availability_Detail__c>();
                        for(wrapper w : availList){
                            if(w.availDetailObj.COH_SC_Provider__c == null)
                                w.availDetailObj.COH_SC_Provider__c = conobj.id;
                            w.availDetailObj.COH_SC_Clinic_Location__c = selectedLocation;
                            avdUpsert.add(w.availDetailObj);
                        }
                        upsert avdUpsert  ;
                        system.debug('===avdUpsert===='+avdUpsert.size());
                    }
                    editMode = false;
                    queryDetails();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Detail saved Successfully.'));
                }catch(Exception e){
                    ApexPages.addMessages(e);
                
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please Select Location.'));
            }
        }
        return null;
    }
    
    
    /**
     @Description : This method will call when user clicks on cancel button on vf page.
      */
    public pageReference doCancel(){
        editMode = false;
        queryDetails();
        return null;
    }
    
    /**
       @Description: When we change location picklist it will change the child object's records accordingly because they are dependent on location.
                     like- NP/PA and Availability Details.
      */
    public pagereference onchaneLocationPopulateDetails(){
        //if(selectedLocation != null && selectedLocation != ''){
            queryDetails();
        //}
        return null;
    }
    
    /**
        @Description: To add new NPPA record row
      */  
    public pagereference addNPPARow(){
        if(validate()){
            if(nppaWrapper == null)
                nppaWrapper = new List<Wrapper>();
            nppaWrapper.add(new wrapper(new COH_SC_NP_PA__c(COH_SC_Provider__c = conobj.id), nppaWrapper.size()));
        }
        return null;
    }
    
    /**
        @Description: To add new Admin record row
      */
    public pagereference addAdminRowRow(){
        if(validate()){
            if(adminSupportList == null)
                adminSupportList = new List<Wrapper>();
            adminSupportList.add(new wrapper(new COH_SC_Admin_Support__c(COH_SC_Provider__c = conobj.id), adminSupportList.size()));
        }
        return null;
    }
    
    /**
        @Description: To add new Availability record row
      */
    public pagereference addAvailDetailRow(){
        if(validate()){
            if(availList == null)
                availList = new List<Wrapper>();
            availList.add(new wrapper(new COH_SC_Availability_Detail__c(COH_SC_Provider__c = conobj.id), availList.size()));
        }
        return null;
    }
    
    /**
        @Description: To add new special Instruction record row
      */
    public pagereference addNewProviderInstructions(){
        if(validate()){
            if(pDetaillist == null)
                pDetaillist = new List<Wrapper>();
            pDetaillist.add(new wrapper(new COH_SC_Provider_Detail__c(COH_SC_Provider__c = conobj.id), pDetaillist.size()));
        }
        return null;
    }
    
    /**
        @Description: To remove NP/PA record row
      */
    public pagereference delNppaRow(){
        if(nppaRow != null && nppaWrapper != null && nppaWrapper.size() > 0){
            removeRow(nppaWrapper, nppaRow, nppaWrapper[nppaRow].nppaObj);
        }
        return null;
    }
    
    /**
        @Description: To remove Admin Support record row
      */
    public pagereference delAdminSupportRow(){
        if(adminRow != null && adminSupportList != null && adminSupportList.size() > 0){
            removeRow(adminSupportList, adminRow, adminSupportList[adminRow].adminSupport);
        }
        return null;
    }
    
    /**
        @Description: To remove Availability Detail record row
      */
    public pagereference delAvailRow(){
        if(availDetRow != null && availList != null && availList.size() > 0){
            removeRow(availList, availDetRow, availList[availDetRow].availDetailObj);
        }
        return null;
    }
    
    /**
        @Description: To remove instruction Detail record row
      */
    public pagereference delProviderInstructionRow(){
        if(instructionOrder != null && pDetaillist != null && pDetaillist.size() > 0){
            removeRow(pDetaillist, instructionOrder, pDetaillist[instructionOrder].pdetail);
        }
        return null;
    }
    
    /**
        @Description: Generic method for removing row .(Deleting record)
        @params : 
            1. WrapperList : Wrapper type list
            2. order       : Integer, it will specify which list index need to remove
            3. obj         : sObject , It Can be different type of object instance Like: Availability Detyail,
                             Admin Support or NP/PA detail 
      */
    public void removeRow(List<Wrapper> wrapperList, Integer order, sObject obj){ 
        if(wrapperList != null && wrapperList.size() > 0 && order != null){
            // Remove Row by its order
            wrapperList.remove(order);
            if(wrapperList.size() > 0 ){
                integer i = 0;
                for(wrapper w :wrapperList){
                    w.order = i;
                    i++;
                }
            }
        }
        
        //If record is already inserted then we also have to remove that record.
        if(obj != null && obj.id != null){
            try{
                delete obj;
            }catch(Exception e){
                // Show error message on vf page.
                apexpages.addMessages(e);
            }
        }
    }
    
    /**
        @Description: When we will select NP/PA from NP/Pa child list(In Edit Mode) then it will polulate phone , email and pager no
                      of selected NP/PA in same row.    
        
      */
    public pagereference populateValuesOnselectNPPA(){
        system.debug('---nppaRow------'+nppaRow);
        if(nppaRow != null && nppaWrapper != null){
            populateDetails(nppaWrapper, nppaRow, (nppaWrapper[nppaRow].nppaObj != null ? nppaWrapper[nppaRow].nppaObj.COH_SC_NP_PA__c : null));
        
        }
        return null;
    }
    
    /**
        @Description: When we will select Admin from Admion Support child list(In Edit Mode) then it will populate phone , email and pager no
                      of selected Admin in same row.    
        
      */
      
    public pagereference populateValuesOnselectadminSupport(){
        system.debug('---adminRow------'+adminRow);
        if(adminRow != null && adminSupportList != null){
            populateDetails(adminSupportList, adminRow, (adminSupportList[adminRow].adminSupport != null ? adminSupportList[adminRow].adminSupport.COH_SC_Admin__c : null));
        
        }
        return null;
    }
    
    /**
        @Description: Generic method for Populating Detail in Child object's on select
        @params : 
            1. WrapperList : Wrapper type list
            2. order       : Integer, it will specify which list index need be populate
            3. contactID   : ID , (Contact Id, Because NP/PA and admin both will be contact so we r using common ID )
                             
      */
    public void populateDetails(List<Wrapper> wrapperList,integer order, Id contactID){
        system.debug('---contactIdcontactId---'+contactId);
        if(contactId != null ){
            //Added Fax in SOQL: Changes by Sanjay 28th July 2021
            Contact c = [Select id, Name, Phone, Email, Page_Email__c,Fax  from Contact where id=: contactId];
            system.debug('---order---'+order);
            if(c != null && wrapperList != null && wrapperList.size() > 0 && order != null){
                wrapperList[order].Email = c.Email != null ? c.Email : '';
                system.debug('---wrapperList[order].Email---'+wrapperList[order].Email);
                if(c.Page_Email__c != null){
                    
                    string pagerstr = cretePagerString(c.Page_Email__c);
                    wrapperList[order].Pager = pagerstr;
                }
                
                wrapperList[order].Phone = c.phone != null ? c.Phone : '';
                wrapperList[order].Fax = c.Fax != null ? c.Fax : ''; //Changes by Sanjay Singh on 28th July 2021
            }
        }
    
    }
   
    /**
        @Description: For proider id null check 
      */
    public boolean validate(){
        if(conObj != null && conobj.id != null)
            return true;
        else
            return false;
    }
    
    
    /**
        @Description: Wrapper class to bind different entiy in sigle unit.
                     
      */
    public class wrapper {
    
        public COH_SC_NP_PA__c nppaObj                      {get; set;}
        public COH_SC_Admin_Support__c adminSupport         {get; set;}
        public COH_SC_Availability_Detail__c availDetailObj {get; Set;}
        public String email                                 {get; set;}
        public integer order                                {get; set;}
        public String phone                                 {get; set;}
        public string pager                                 {get; set;}
        public string fax                                   {get; set;}//Changes by Sanjay Singh on 16th July 2021
        public COH_SC_Provider_Detail__c pdetail            {get; set;}
        
        public wrapper(COH_SC_NP_PA__c np, Integer i){
            this.nppaObj = np;
            this.order   = i;
        }
        
        public wrapper(COH_SC_Provider_Detail__c pd, Integer i){
            this.pdetail = pd;
            this.order   = i;
        }
        
        public wrapper(COH_SC_Admin_Support__c asd, Integer i){
            this.adminSupport = asd;
            this.order   = i;
        }
        
        public wrapper(COH_SC_Availability_Detail__c avd, Integer i){
            this.availDetailObj = avd;
            this.order   = i;
        }
        
    } 
    
}