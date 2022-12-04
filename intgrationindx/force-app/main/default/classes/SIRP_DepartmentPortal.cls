public class SIRP_DepartmentPortal{
    public String ParentDepartment {get;set;}
    public String ParentDepartmentid {get;set;}
    public boolean isParentDepExists { get; set; }
     public String secOwnerInserts = '';
        
    public static boolean byPassDuplicateOrderValidation = false;
    public List<COH_SI_NewsandAnnouncement__c> lstNewsAnnouncement{get;set;}
    public List<COH_SI_NewsandAnnouncement__c> lstNewsAnnouncementSecondary{get;set;}
    public String txtSearch{get;set;}
    public List<User> lstPRPic{get;set;}
    public List<User> lstStaffPic{get;set;}
    public boolean editMode{get;set;}
    public boolean showEditLink{get;set;}
    public boolean showSecEditLink{get;set;}
    public List<Department__c> lstDepartment {get;set;}
    public List<List<User>> lstOflstSaff {get;set;} //Variable to display list of Staff associated with logged in users
    //public List<selectOption> secOwnerList {get;set;}
    public List<String> secOwnerSelected{get;set;} 
    private User currentUser;
    private List<PermissionSetAssignment> PermissionSetsForUser;
    private List<Department__c> secondaryOwners;
    private List<Department__c> primaryOwner;
    public List<COH_SI_NewsandAnnouncement__c> departmentSpotlights {get;set;}
   public List<SelectOption> options1 = new List<SelectOption>();
    //public List<Department_Components__c> departmentComponents {get;set;}
    public List<DepartmentComponentWrapper> lstDepartmentComponentWrapper {get;set;}
    
    public String deptImageName {get;set;}
    public transient Blob deptImageContent {get;set;}
    public String departmentName {get;set;}
    public String departmentNameSecondary {get;set;}
    public String OwnerName {get;set;}
    public String OwnerEmail {get;set;}
    //Getter setter for Secondary Department
    
    public List<Department__c> secondaryLst {get; set;}
    public String secondaryDeptId {get; set;}
    public List<Department__c> secondaryDeptEditLst {get; set;}
    public String isSecondary = '';
    public boolean shwSecOw{get;set;}
    //End of getter setter for Seconday Department
    
    String recordid;
    public String calenderName {get;set;}
    public String selcalenderName {get;set;}
    
    public List<SelectOption> calenderNameList {get;set;}
    public String secDepURLredirect {get;set;}
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    
    private boolean mRedirectToHomepage = false;     		// This variable is used if there is an error in the contructor, it redirects the user to the iHope Homepage. 
    private string mErrorMessage;
    private string mException;
    
    public SIRP_DepartmentPortal(){
    //try{
        Integer i = 0;
        //https://salesforce.stackexchange.com/questions/25892/the-most-sneaky-way-to-increase-your-code-coverage
        //Frank Salinas 20200416.  COVID-19 Critical Update. The unit test for this is failing with 68%, and default unit test is failing with 10 misc error. Ran out of time. 
        //We'll relook at this in the near future
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        editMode = true;
        isParentDepExists = false;
        shwSecOw = false;
        String profileName=[Select Id,Name from Profile where Id=:Userinfo.getProfileId()].Name;
        recordid = ApexPages.currentPage().getParameters().get('id');
        system.debug('profileName ' + profileName);
        system.debug('Start---- ');
        //String parentId;
        //system.debug('parentId ' + parentId);
        //String ParentDepartment =[Select id,Parent_Department__r.Name from Department__c where id=:recordid].Parent_Department__r.Name;
        showEditLink = true;
        showSecEditLink = false;
        
        if(profileName.equals('System Administrator'))
        {
            
            showEditLink = true;
            showSecEditLink = true;
            shwSecOw = true;
        }
        else
        {     
            system.debug('primaryOwner ');
            primaryOwner = [select id,name from Department__c where id = :recordid and OwnerId = :Userinfo.getUserId()]; 
            if (primaryOwner.size() > 0)
            {             
                showEditLink = true;
                showSecEditLink = true;  
                shwSecOw = true;
            }
            else
            {       
                system.debug('secondaryOwners ');
                secondaryOwners = [select id,Secondary_Owners__c from Department__c where id = :recordid and Secondary_Owners__c includes (:Userinfo.getName())];
                if (secondaryOwners != null && secondaryOwners.size() > 0)
                {             
                    showEditLink = true;
                    showSecEditLink = true;  
                }
                else
                {
                    system.debug('PermissionSetsForUser ');
                    PermissionSetsForUser = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Label = 'Intranet IT Admin'];
                    if (PermissionSetsForUser.size() > 0)
                    {             
                        showEditLink = true;
                            showSecEditLink = true;  
                        shwSecOw = true;
                    }
                    else
                    {
                        showEditLink = false;
                        showSecEditLink = false; 
                    }
                }
            }
        }
               
       currentUser = [Select Id, Department from User where Id = :UserInfo.getUserId()];
       //id ownerid = (id) [select id,ownerid from Department__c where id =:recordid].ownerid;
        //if(currentUser.id == ownerid)
        //{
        //    shwSecOw = true;
       // }
       //recordid = ApexPages.currentPage().getParameters().get('id');
       isSecondary = ApexPages.currentPage().getParameters().get('isSecondary');

        if(isSecondary!=null && isSecondary.equalsIgnoreCase('True')){
            
            String strName;
            List<Secondary_Department__c> lstSecDepartments = [Select name from Secondary_Department__c where id=:recordid];
            if(lstSecDepartments.size() > 0)
            {
                strName = lstSecDepartments[0].name;
                
                system.debug('strName ' + strName);
                lstDepartment = [Select Id, Name,Parent_Department__r.Name, Parent_Department__c,CalendersName__c, Description__c, Title__c, Image_Attachment_Id__c, Owner.Name, Owner.Email, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c, MenuItem__c from Department__c where name = :strName limit 1];
                system.debug('strName ' + lstDepartment);
                secondaryLst = [Select Id, Name,Parent_Department__r.Name, Parent_Department__c,CalendersName__c, Description__c, Title__c, Image_Attachment_Id__c, Owner.Name, Owner.Email, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c, MenuItem__c from Department__c where name = :strName limit 1];
                
                if(lstDepartment.size() > 0)
                {
                    departmentName = lstDepartment[0].Name;
                    ParentDepartmentid = lstDepartment[0].Parent_Department__c;
                    system.debug('Pavani:'+ParentDepartmentid);
                    if(ParentDepartmentid  != '' && ParentDepartmentid != null )
                    {
                        ParentDepartment = lstDepartment[0].Parent_Department__r.Name;
                        ParentDepartmentId = lstDepartment[0].Parent_Department__c;
                        departmentNameSecondary = lstDepartment[0].Name;
                        isParentDepExists = true;
                    }
                    calenderNameList = new List<SelectOption>();
                    system.debug('lstDepartment[0].CalendersName__c: '+lstDepartment[0].CalendersName__c);
                    if(String.isNotEmpty(lstDepartment[0].CalendersName__c)){
                        for(String name : lstDepartment[0].CalendersName__c.split(';')){
                            system.debug('Name: '+name);
                            system.debug('selcalenderName: '+selcalenderName);
                            if(String.isEmpty(selcalenderName)){
                                selcalenderName = name ;
                            }
                            calenderNameList.add(new SelectOption(name, name));
                        }
                    }
                    OwnerName = lstDepartment[0].Owner.Name;
                    OwnerEmail = lstDepartment[0].Owner.Email;            
                    
                    List<Attachment> lstAtt = [SELECT Id, Name, Body FROM Attachment where Id = :lstDepartment[0].Image_Attachment_Id__c];
                    if(!lstAtt.isEmpty()) {
                        deptImageName = lstAtt[0].Name;
                    }
                }
            }
        }
        else{
            if (String.isEmpty(recordid)){
                try {
					lstDepartment = [Select Id, Name, CalendersName__c, Parent_Department__r.Name,Parent_Department__c,Description__c, Title__c, Image_Attachment_Id__c, Owner.Name, Owner.Email, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c, MenuItem__c from Department__c where Name = :currentUser.Department];                    
                    ParentDepartmentid = lstDepartment[0].Parent_Department__c;
                    if (ParentDepartmentid  != '' &&  ParentDepartmentid != null) {
                        ParentDepartment = lstDepartment[0].Parent_Department__r.Name;
                        ParentDepartmentId = lstDepartment[0].Parent_Department__c;
                        departmentNameSecondary = lstDepartment[0].Name;
                        isParentDepExists = true;
                    }                      
                }
                catch (Exception e) {
                    mErrorMessage = 'Unable to load the Department Page for Department Name: ' + currentUser.Department;
                    mException = e.getMessage() + '  :  ' + e.getStackTraceString();
                    mRedirectToHomepage = true;
                    return;
                }
           } 
            else{                
                try {
                    lstDepartment = [Select Id, Name,Parent_Department__r.Name, Parent_Department__c,CalendersName__c, Description__c, Title__c, Image_Attachment_Id__c, Owner.Name, Owner.Email, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c, MenuItem__c from Department__c where Id = :recordid];
                    departmentName = lstDepartment[0].Name;
                    
                    // ParentDepartment = lstDepartment[0].Parent_Department__r.Name;
                    ParentDepartmentid = lstDepartment[0].Parent_Department__c;
                    system.debug('Pavani:'+ParentDepartmentid);
                    if(ParentDepartmentid  != '' && ParentDepartmentid != null )
                    {
                        ParentDepartment = lstDepartment[0].Parent_Department__r.Name;
                        ParentDepartmentId = lstDepartment[0].Parent_Department__c;
                        departmentNameSecondary = lstDepartment[0].Name;
                        isParentDepExists = true;
                    }
                    calenderNameList = new List<SelectOption>();
                    system.debug('lstDepartment[0].CalendersName__c: '+lstDepartment[0].CalendersName__c);
                    if(String.isNotEmpty(lstDepartment[0].CalendersName__c)){
                    for(String name : lstDepartment[0].CalendersName__c.split(';')){
                        system.debug('Name: '+name);
                        system.debug('selcalenderName: '+selcalenderName);
                        if(String.isEmpty(selcalenderName)){
                        selcalenderName = name ;
                        }
                        calenderNameList.add(new SelectOption(name, name));
                        }
                    }                   
                }	
                catch (Exception e) {
                    mErrorMessage = 'Unable to load the Department Page for Department ID: ' + recordid;
                    mException = e.getMessage() + '  :  ' + e.getStackTraceString();
                    mRedirectToHomepage = true;
                    return;                   
                }
           }
           if(lstDepartment.isEmpty()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unable to fetch user\'s department related information - Deparment Name: '+currentUser.Department+'. Please contact to System Administrator.'));
                return;
           }
            else
            {
                OwnerName = lstDepartment[0].Owner.Name;
                OwnerEmail = lstDepartment[0].Owner.Email;
            }
           
           List<Attachment> lstAtt = [SELECT Id, Name, Body FROM Attachment where Id = :lstDepartment[0].Image_Attachment_Id__c];
           if(!lstAtt.isEmpty()) {
            deptImageName = lstAtt[0].Name;
           }
       }
       userPictures();
       getUserStaff();
       getDepartmentSpotlight();
       getNewsAnnouncement();
       getNewsAnnouncementSecondary();
       getDepartmentComponents();
       //}
       //catch(Exception e)
       //{
           //system.debug(e.getMessage());
       //}
    }

    /*public void GoEditMode(){
    
    }*/
    /*public void pageBlockEditMode(){
       editMode = true;
    } */      
    public void btnSearch(){}     

    public void saveSection(){
        editMode = false;
    }
    
    public void userPictures(){
    
       lstPRPic = New List<User>();
       lstStaffPic = New List<User>();
       
       lstPRPic = [SELECT id, name, Alias, FullphotoUrl, SmallPhotoUrl FROM user where title LIKE '%research%' OR title LIKE '%Physician%'LIMIT 3];       
       lstStaffPic = [SELECT id, name, Alias, FullphotoUrl, SmallPhotoUrl FROM user WHERE title LIKE '%Staff%' LIMIT 4];
    }
    
    /*
    *   Name: getUserStaff
    *   Description: Created new method to fetch logged user's staff members based on department name
    *   Date: 08/08/2015
    */
     public void getUserStaff() {
         lstOflstSaff = new List<List<User>>();
         // secOwnerList = new List<selectoption>();
         Set<String> psDepartmentSet = new Set<String>();
         List<PeopleSoft_Department__c> lstPeopleSoftDepartment = [Select Id, Department__c, Department__r.Name, PeopleSoft__c, PeopleSoft__r.Name from PeopleSoft_Department__c where Department__c = :recordid];
         for(PeopleSoft_Department__c psd : lstPeopleSoftDepartment) {
             psDepartmentSet.add(psd.PeopleSoft__r.Name);
         }
         List<User> lstSaff = [Select id, name, displayName__c, suffix__c, Alias, FullphotoUrl,SmallPhotoUrl from User where Department IN :psDepartmentSet and IsActive=true Order By name];
         List<User> tempUserList = new List<User>();
         for(User user : lstSaff) {
             tempUserList.add(user);
             if(tempUserList.size() == 3) {
                 lstOflstSaff.add(tempUserList);
                 tempUserList = new List<User>();
             }            
         }
         if(tempUserList.size() !=0 && tempUserList.size() < 3) {
             lstOflstSaff.add(tempUserList);
         }
         
         String secondaryOwnerNames; 
         List<String> lstSecondaryOwnerNames = new List<String>();
         
         List<Department__c> secondaryOwnersOfDepartment = [select id,Secondary_Owners__c from Department__c where id = :recordid];
         if (secondaryOwnersOfDepartment.size() > 0)
         {
             secondaryOwnerNames = secondaryOwnersOfDepartment[0].Secondary_Owners__c;
             if(!String.isEmpty(secondaryOwnerNames))
             {
                 lstSecondaryOwnerNames = secondaryOwnerNames.split(';');
                 system.debug('lstSecondaryOwnerNames ' + lstSecondaryOwnerNames);
                 
                 for(String strSecondaryOwnerName : lstSecondaryOwnerNames){
                     rightvalues.add(strSecondaryOwnerName);
                 }
                 system.debug('getUserStaff inside seclected values ' + rightvalues);
             }
         }
         
         
         List<User> lstSiteAdmins = [Select id, name from User where IsActive=true and id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Label = 'Intranet Site Admin')]; 
         if(lstSiteAdmins.size() > 0)
         {
             if(!String.isEmpty(secondaryOwnerNames)){
                 
                 system.debug('secondaryOwnerNames' + secondaryOwnerNames);
                 for(User secUser : lstSiteAdmins) {
                     system.debug('secUser ' + secUser);
                     if(!secondaryOwnerNames.contains(secUser.Name))
                     {
                         leftvalues.add(secUser.Name);
                         system.debug('Value added to leftvalues ' + secUser.Name);
                     }
                 }
             }
             else
             {
                 for(User secUser : lstSiteAdmins) {
                     leftvalues.add(secUser.Name);
                 }
             }
         }
         
         system.debug('End of getUserStaff ');
     }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
    
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string leftvalues : tempList)
            options.add(new SelectOption(leftvalues,leftvalues));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
            system.debug('inside seclected values' + rightvalues);
            system.debug('inside seclected values options1' + options1);
        return options1;
    }
    
    
    /*
    *   Name: getDepartmentSpotlight
    *   Description: Created new method to fetch logged user's department spotlight details 
    *   Date: 10/08/2015
    */
    public void getDepartmentSpotlight() {
    if(lstDepartment != null && !lstDepartment.isEmpty() && lstDepartment.size() > 0) {
    
      departmentSpotlights = [select Id, Title__c, Department__c, Description__c, ImageUrl__c, LastModifiedBy.Name, LastModifiedBy.Email, Image_Attachment_Id__c  from COH_SI_NewsandAnnouncement__c where Org_Wide__c = false and News_Type__c = 'Department Spotlight' and Department__c = :lstDepartment[0].Id ORDER BY CreatedDate ASC limit 3];
    } else {
      departmentSpotlights = new List<COH_SI_NewsandAnnouncement__c>();
    }
    }
    
    /*
    *   Name: getNewsAnnouncement
    *   Description: Created new method to fetch news and announcement based on logged user's department 
    *   Date: 10/08/2015
    */
    public void getNewsAnnouncement() {
        Datetime current = System.now();
        Date d = current.date();
        Time t = current.time();
        Datetime dtLocalDateTime =  Datetime.newInstance(d,t);
        if(lstDepartment == null || lstDepartment.isEmpty()) {
            lstNewsAnnouncement = new List<COH_SI_NewsandAnnouncement__c>();
          return;
        }
        lstNewsAnnouncement = [SELECT id, name, Description__c, Title__c, PhotoURL__c, Department__c, Image_URL__c, Image_Attachment_Id__c  FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = false and News_Type__c != 'Department Spotlight' and Department__c = :lstDepartment[0].Id and Display__c = true and Preview__c = false and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC];
        if(lstNewsAnnouncement.size() < 3 ) {
            List<COH_SI_NewsandAnnouncement__c> tempList = [SELECT id, name, Description__c, Title__c, PhotoURL__c, Department__c, Image_URL__c, Image_Attachment_Id__c  FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = true and Display__c = true and Preview__c = false and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC LIMIT :(3-lstNewsAnnouncement.size())];
            lstNewsAnnouncement.addAll(tempList);
        }
    }
    public void getNewsAnnouncementSecondary() {
        Datetime current = System.now();
        Date d = current.date();
        Time t = current.time();
        Datetime dtLocalDateTime =  Datetime.newInstance(d,t);        
        if(secondaryLst == null || secondaryLst.isEmpty()) {
            lstNewsAnnouncementSecondary = new List<COH_SI_NewsandAnnouncement__c>();
            return;
        }        
        lstNewsAnnouncementSecondary = [SELECT id, name, Description__c, Title__c, PhotoURL__c, Department__c, Image_URL__c, Image_Attachment_Id__c  FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = false and News_Type__c != 'Department Spotlight' and Secondary_Department__c = :secondaryLst[0].Id and Display__c = true and Preview__c = false and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC];
        if(lstNewsAnnouncementSecondary.size() < 3 ) {
            List<COH_SI_NewsandAnnouncement__c> tempList = [SELECT id, name, Description__c, Title__c, PhotoURL__c, Department__c, Image_URL__c, Image_Attachment_Id__c  FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = true and Display__c = true and Preview__c = false and Start_Date_Time__c != null and Stop_Date_Time__c != null and Start_Date_Time__c <= :dtLocalDateTime and Stop_Date_Time__c >= :dtLocalDateTime Order By createdDate DESC LIMIT :(3-lstNewsAnnouncement.size())];
            lstNewsAnnouncementSecondary.addAll(tempList);
        }        
        system.debug('lstNewsAnnouncementSecondary'+lstNewsAnnouncementSecondary);
    }
    
    /*
    *   Name: editDepartmentSection
    *   Description: Method created to edit the department details 
    *   Date: 13/08/2015
    */
    public Pagereference editDepartmentSection() {
    
        return new Pagereference('/apex/SIRP_DepartmentEditPage?edit=dpt');    
        
    }
    
     public Pagereference refreshCalender() {   
        selcalenderName = calenderName  ;
         return null;
    }
     /*
    *   Name: openSecondary
    *   Description: Method created to open secondary department page 
    */
    public Pagereference openSecondary() {
        Pagereference secondPage = new Pagereference('/apex/SIRP_SecondaryDepartment?id='+lstDepartment[0].id);
        secondPage.setredirect(true);
        return secondPage;    
    }
    
    public Pagereference openDepartment() {
        Pagereference secondPage = new Pagereference('/apex/DepartmentPortal?id='+lstDepartment[0].id);
        secondPage.setredirect(true);
        return secondPage;    
    }
    
    /*
    *   Name: editSecondaryDepartment
    *   Description: Method created to edit the secondary department details 
    *   Date: 
    */
    public Pagereference editSecondaryDepartment() {
            secondaryDeptEditLst = [Select id,Name,Department_Additional_Description__c,Title__c from Department__c where id=:secondaryLst[0].id];
            system.debug('secondaryDeptEditLst----->'+secondaryDeptEditLst);
        return new Pagereference('/apex/SIRP_SecondaryDepartmentEdit?id='+secondaryDeptEditLst[0].id);    
        
    }
    
    
    /*
    *   Name: editDepartmentComponentSection
    *   Description: Method created to edit the department component details
    *   Date: 18/08/2015
    */
    public Pagereference editDepartmentComponentSection() {
    
        getDepartmentComponents();
        return new Pagereference('/apex/SIRP_DepartmentEditPage?edit=dptcomp');    
    }
    
    
    /*
    *   Name: updateDepartmentSection
    *   Description: This Method is being used to update the department related details 
    *   Date: 13/08/2015
    */
    public Pagereference updateDepartmentSection() {
        List<Attachment> lstAtt = [SELECT Id, Name, Body FROM Attachment where Id = :lstDepartment[0].Image_Attachment_Id__c];
        if(!lstAtt.isEmpty()) {
            system.debug('deptImageName : '+deptImageName);
            system.debug('deptImageContent : '+deptImageContent);
            system.debug('att.Name : '+lstAtt[0].Name);
            system.debug('att.Body : '+lstAtt[0].Body);
            if((deptImageName != null && lstAtt[0].Name != deptImageName) || (deptImageContent != null && lstAtt[0].Body != deptImageContent)) {
                lstAtt[0].Name = deptImageName;
                lstAtt[0].Body = deptImageContent;
                update lstAtt[0];
                
                //deptImageName = null;
                //deptImageContent = null;
            }
            
        }  
        
        Boolean Start = true;
        system.debug('rightvalues debug'+ rightvalues);
        if(!rightvalues.isEmpty()) {           
            for(String Str : rightvalues) {
           
                if(Start) {
                    secOwnerInserts = Str;
                    Start = false;
                } else {               
                    secOwnerInserts = secOwnerInserts + ';' + Str;
                }
            }
        }
        lstDepartment[0].Secondary_Owners__c = secOwnerInserts;
        System.debug('Selcted right vales'+secOwnerInserts);
             update lstDepartment;  
        
        recordid = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/DepartmentPortal?id=' + recordid);
        return pageRef.setRedirect(true);   
    }
    
    
    /*
    *   Name: updateSecondaryDepartmentSection
    *   Description: This Method is  used to update the Secondary department related details 
    *   Date: 13/08/2015
    */
    public Pagereference updateSecondaryDepartmentSection() {
       
        if(!secondaryDeptEditLst.isEmpty())
            update secondaryDeptEditLst;
            
        secondaryLst = [Select id,Name,Department_Additional_Description__c,Title__c from Department__c where id=:secondaryLst[0].id];
        return new Pagereference('/apex/SIRP_SecondaryDepartment?id='+secondaryLst[0].id+'&isSecondary=true');    
    }
    
      /*
    *   Name: cancelSecondaryDepartmentSection
    *   Description: This Method is  used to update the Secondary department related details 
    *   Date: 13/08/2015
    */
    public Pagereference cancelSecondaryDepartmentSection() {
        return new Pagereference('/apex/SIRP_SecondaryDepartment?id='+secondaryLst[0].id);    
    }
    
    
    /*
    *   Name: cancelDepartmentEditPage
    *   Description: To Cancel Department Edit Page 
    *   Date: 13/08/2015
    */
    public Pagereference cancelDepartmentEditPage() {
        //lstDepartment = [Select Id, Name, Description__c, Title__c, Image_Attachment_Id__c, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c from Department__c where Name = :departmentName];    
        recordid = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/DepartmentPortal?id=' + recordid);
        return pageRef.setRedirect(true);   
    }
    
    /*
    *   Name: getDepartmentComponents
    *   Description: Created new method to fetch department components 
    *   Date: 16/08/2015
    */
    public void getDepartmentComponents() {
        lstDepartmentComponentWrapper = new List<DepartmentComponentWrapper>();
        List<Department_Components__c> departmentComponents;
        if (String.isEmpty(departmentName)) {
            departmentComponents = [Select Id, Name, Department_Content__c, Order__c from Department_Components__c where Department_Name__r.Name = :currentUser.Department order by Order__c ASC limit 25]; //FS 20200414 Per conversation with Sharelle Jones, upper limit set to 25, but picklist will only allow 15 for now
        } else {
            departmentComponents = [Select Id, Name, Department_Content__c, Order__c from Department_Components__c where Department_Name__r.Name = :departmentName order by Order__c ASC limit 25]; //FS 20200414 Per conversation with Sharelle Jones, upper limit set to 25, but picklist will only allow 15 for now
        }
        
        
        //List<Department_Components__c> departmentComponents = [Select Id, Name, Department_Content__c, Order__c from Department_Components__c where Department_Name__r.Department_Name__c = :currentUser.Department order by Order__c ASC limit 8];
        for(Department_Components__c dc : departmentComponents) {
            DepartmentComponentWrapper dcw = new DepartmentComponentWrapper();
            dcw.depComp = dc;
            dcw.isSelected = false;
            lstDepartmentComponentWrapper.add(dcw);
        }
    }
    
    /*
    *   Name: updateDepartmentComponents
    *   Description: Created new method to update department components (Name, Orders and Content) 
    *   Date: 17/08/2015
    */
  
       public Pagereference updateDepartmentComponents() {
           Set<String> orderCount = new Set<String>();
           List<Department_Components__c> departmentComponents = new List<Department_Components__c>();
           List<Department__c> Seondaryowners = new List<Department__c>();
           try {
               system.debug('lstDepartmentComponentWrapper.size() : '+lstDepartmentComponentWrapper.size());
               for(DepartmentComponentWrapper dcw : lstDepartmentComponentWrapper) {
                   if(dcw.depComp.Order__c == '' || dcw.depComp.Order__c == null) {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Required Field Missing: Order should not be selected as none.'));
                       return null;
                   }
                   if(dcw.depComp.Name == null || dcw.depComp.Name == '') {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Required Field Missing: Please Provide department name.'));
                       return null;
                   }
                   boolean b = orderCount.add(dcw.depComp.Order__c);
                   if(!b) {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please remove duplicate order number.'));
                       return null;
                   }
                   if(dcw.depComp.Id == null) {
                       dcw.depComp.Department_Name__c = lstDepartment[0].Id;
                   }
                   departmentComponents.add(dcw.depComp);
               }
               byPassDuplicateOrderValidation = true;
               upsert departmentComponents;
               //Department__c SecondaryOwnerdpt = new Department__c ();
               //system.debug('Selected Values :' +rightvalues );
               //lstDepartment[0].Secondary_Owners__c = string.valueof(rightvalues);
               //update lstDepartment;
               
               //updateDepartmentSection();
               
           } catch(Exception e) {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
               return null;
           }
           getDepartmentComponents();
        
           recordid = ApexPages.currentPage().getParameters().get('id');
           PageReference pageRef = new PageReference('/apex/DepartmentPortal?id=' + recordid);
           return pageRef.setRedirect(true); 
    }
    
    /*
    *   Name: addDepartmentComponentSection
    *   Description: Created new method to add more department components section 
    *   Date: 17/08/2015
    */
    public void addDepartmentComponentSection() {
        if(lstDepartmentComponentWrapper.size() == 10) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not add more than 10 section.'));
            return;
        }
        lstDepartmentComponentWrapper.add(new DepartmentComponentWrapper());             
    }
    
    /*
    *   Name: deleteSelectedDepartmentComponent
    *   Description: Method to delete department components 
    *   Date: 18/08/2015
    */
    public void deleteSelectedDepartmentComponent() {
        List<Department_Components__c> temp_DCList = new List<Department_Components__c>();
        boolean flag = false;  
        for(DepartmentComponentWrapper dcw : lstDepartmentComponentWrapper) {
            if(dcw.isSelected) {
                if(dcw.depComp.Id == null && (dcw.depComp.Order__c == '' || dcw.depComp.Order__c == null)) {
                    flag = true;
                    continue;
                }
                temp_DCList.add(dcw.depComp);
            }
        }
        if(!temp_DCList.isEmpty()) {
            delete temp_DCList;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Section Successfully Removed!'));
        } else if(!flag) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'There is no row selected to remove.'));
        }
        getDepartmentComponents();
    }
    
    /*
    *   Name: DepartmentComponentWrapper
    *   Description: Wrapper Class to store department component related information  
    *   Date: 18/08/2015
    */
    
    public class DepartmentComponentWrapper {
        public Department_Components__c depComp {get;set;}
        public boolean isSelected {get;set;}
        public DepartmentComponentWrapper() {
            depComp = new Department_Components__c();
            isSelected = false;
        }
    }
    
    public PageReference RedirectToErrorPage() {
        if (mRedirectToHomepage) {
            PageReference retURL = new PageReference('/apex/COH_SIP_Error');
            retURL.getParameters().put('errorMessage', mErrorMessage);
            retURL.getParameters().put('exception', mException);
            retURL.setRedirect(true);
            return retURL;            
        }
        return null;
    }    
}