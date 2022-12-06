/* 
 * This class contains the methods for working on User objects.
 * 
 * Raymond Tam, Tim Hughes
 * City of Hope
 * Copyright (c) 2017
 *  
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHUserHelper {

    private static final String ITS_ASSET_REQUEST_APPLICATION = 'ITS Asset Request';
    private static final String GET_USERS_SOQLQuery = 'select Id, Mgr__c,VP_SVP_CTO__c, Email, FirstName, LastName, Title, EmployeeNumber, Location__c, Department, Start_Date__c from User where Id in :userIDList';

    // Default email address can be testing in a pre-production roll-out of ITS Asset Requests.
    // The new Users data feed is available only in production.  This will 
    // override the department manager email and allow the Salesforce
    // administrator to verify that things are working correctly.  When the 
    // application goes live, this can be used with a valid email address.  Otherwise,
    // the managers will receive emails from themselves for ITS Asset Requests
    private static final String DEFAULT_EMAIL_ADDRESS = 'Default email address';
    
    // Default Org Wide Email address for ITS Asset Request emails
    private static final String ITS_ORG_WIDE_EMAIL_NAME = 'ITS Org Wide Email';

    private static List<ITSAssetRequest__c> mAssetRequestObjectList = new List<ITSAssetRequest__c>();
    private static Map<Id, String> mIDToEmailMap = new Map<Id, String>();   // Map supervisor and manager emails to their object IDs
    private static Map<Id, User> mIDtoUserMap = new Map<Id, User>();        // Map supervisor and managers to their User objects

    // Default email address for production if required
    private static String mDefaultEmailAddress = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, 
                                                                                        DEFAULT_EMAIL_ADDRESS);
    private static String mITSOrgWideEmailName = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, 
                                                                                           ITS_ORG_WIDE_EMAIL_NAME);
    
    // Globals used for determining the Directors and VPs
    private static Set<User> allActiveDirectorsSet;                                             // Set of all Users who have a VP as their Mgr__c (AK Directors)
    private static Set<Id> VPIds;                                                               // Set of VP Users RecordIDs. Utilizes COH_App_Configuration
    private static Map<String, User> allActiveEmployeesByEmployeeNumberMap;                     // Map of all active employees Key: Employee Number
    private static Map<Id, User> allActiveEmployeesByRecordIdMap;                               // Map of all active employees Key: RecordID    
    
    // Globals used in autoassigning Permission Sets based on ITS_Timesheet checkbox
    private static final String PERMSSION_SETS = 'Permission Sets';
    private static final String ITS_TIMESHEET = 'ITS Timesheet'; 
    private static final String USER_ACTIVE_STATUS = 'A';
    
    private static List<String> mTimesheetPermissionSetIdList;
    private static Map<String, PermissionSetAssignment> mEmployeeTimesheetPermissionSetsByCombinedId;
    
    // For ITS Asset Request emails
    private static Id mITSOrgWideEmailAddressID =  null;
    
    /*
     * Default constructor.
     * 
     */
    public void COHUserHelper() {
    }
    
    /*
     * Process the new User objects.
     * 
     * @param userList      List of new user object IDs.
     * 
     */
    @future
    public static void processNewUsers(List<Id> userIDList) {
      List<User> userList = Database.query(GET_USERS_SOQLQuery);
        
        if (COHUtil.isValidList(userList)) {
            // Get a list of the object IDs of all managers and supervisors
            List<Id> managerAndSupervisorIDs = new List<Id>();
            for (User userObj : userList)  {
                if (!String.isEmpty(userObj.Mgr__c)) {
                    managerAndSupervisorIDs.add(userObj.Mgr__c);
                }
                if (!String.isEmpty(userObj.VP_SVP_CTO__c)) {
                    managerAndSupervisorIDs.add(userObj.VP_SVP_CTO__c);
                }
            }
            OrgWideEmailAddress[] oweaList = [select Id from OrgWideEmailAddress where Address = :mITSOrgWideEmailName];
            if (COHUtil.isValidList(oweaList)) {
                mITSOrgWideEmailAddressID = oweaList.get(0).Id;
            }                
            
            List<User> managerAndSupervisorList = [select Id, Name, Email from User where Id in :managerAndSupervisorIDs];
            
            Map<Id, User> IDtoUserMap = new Map<Id, User>();        // Map IDs of supervisor and manager to their User records
            Map<Id, String> IDToEmailMap = new Map<Id, String>();   // Map IDs of supervisor and manager to their emails
            Map<Id, String> IDToNameMap = new Map<Id, String>();    // Map IDs of supervisor and manager to their names
            if (COHUtil.isValidList(managerAndSupervisorList)) {
                for (User userObj : managerAndSupervisorList) {
                    IDToEmailMap.put(userObj.Id, userObj.Email);
                    IDtoUserMap.put(userObj.Id, userObj);
                    IDToNameMap.put(userObj.Id, userObj.Name);
                }
            }
            
            // Build the new ITSAssetRequest__c objects
            List<ITSAssetRequest__c> assetRequestObjectList = new List<ITSAssetRequest__c>();
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            
            for (User userObj : userList)  {
                ITSAssetRequest__c assetRequestObj = new ITSAssetRequest__c();
                // The Employee_Name__c field should be populated with the value
                // from the userObj.Name field.  However, that seems to be a derived
                // field whose value is null at this point.  Hence, the name needs
                // to be manually constructed.
                assetRequestObj.Employee_Name__c = userObj.FirstName + ' ' + userObj.LastName;
                assetRequestObj.Position__c = userObj.Email;
                assetRequestObj.Dept_Manager__c= userObj.Mgr__c;
                assetRequestObj.Dept_VP__c = userObj.VP_SVP_CTO__c;
                assetRequestObj.VP_Email__c = IDToEmailMap.get(userObj.VP_SVP_CTO__c);
                assetRequestObj.Employee_ID_No__c = userObj.EmployeeNumber;
                assetRequestObj.Work_Location__c = userObj.Location__c;
                assetRequestObj.Dept_ID__c = userObj.Department;
                assetRequestObj.Employee__c = userObj.Id;
                assetRequestObj.Start_Date__c = userObj.Start_Date__c;
                assetRequestObj.Dept_Manager_Name__c = IDToNameMap.get(userObj.Mgr__c);
              
                assetRequestObjectList.add(assetRequestObj);
            }
            
            // Insert the ITSAssetRequest__c objects so they will have object IDs
            if (COHUtil.isValidList(assetRequestObjectList)) {

                try {
                    Database.insert(assetRequestObjectList);
                } catch (Exception e) {
                    throw new COHException('COHUserHelper.processNewUsers(): Could not insert ITSAssetRequest__c records: ' + e.getMessage());
                }
                // Create the email for each newly-added ITSAssetRequest__c object
                for (ITSAssetRequest__c assetRequestObj : assetRequestObjectList) {
                    Id managerID = assetRequestObj.Dept_Manager__c;
                    String managerEmail = IDToEmailMap.get(managerID);
                    User manager = IDtoUserMap.get(managerID);
                    Messaging.SingleEmailMessage emailMessage = createITSAssetRequestEmailMessage(manager, assetRequestObj);
                    if (emailMessage != null) {
                        emailList.add(emailMessage);
                    }
                }
            }

            if (COHUtil.isValidList(emailList) && !Test.isRunningTest()) {
                try {
                    Messaging.sendEmail(emailList);
                } catch (Exception e) {
                    throw new COHException('COHUserHelper.processNewUsers(): Could not send emails: ' + e.getMessage());
                }
            }
        }
    }    

    /* 
     * Updates the User's assigned permission sets included in the COH_App_Configuration Group: ITS Timesheet 
     * & Application Name: Permission Sets.
     * 
     * @param userList       List of users whose permission sets are being updated
     */
    public static void updateTimesheetPermissions(List<User> userList) {
        if (COHUtil.isValidList(userList)) {
            List<PermissionSetAssignment> permissionSetsToAdd = new List<PermissionSetAssignment>();
            List<PermissionSetAssignment> permissionSetsToRemove = new List<PermissionSetAssignment>();
            for (User currentUser : userList) { 
                if (currentUser.IsActive) {
                    populateTimesheetPermissionSetIdList(); 
                    if (COHUtil.isValidList(mTimesheetPermissionSetIdList)) {
                        populateEmployeeTimesheetPermissionSetsByCombinedId();
                        if (mEmployeeTimesheetPermissionSetsByCombinedId != null) {
                            if (currentUser.ITS_Timesheet__c == true) {
                                for (String permissionSetId : mTimesheetPermissionSetIdList) {
                                    // Check to see if currentUser is assigned the permissionSetId
                                    if (mEmployeeTimesheetPermissionSetsByCombinedId.get((String) currentUser.Id + permissionSetId) == null) {
                                        // If the currentUser is NOT assigned the permissionSetId, create a new permission set assignment and add it to the list of permission sets to add
                                        PermissionSetAssignment tempPermissionSetAssignment = new PermissionSetAssignment(AssigneeId = currentUser.Id, PermissionSetId = permissionSetId);
                                        permissionSetsToAdd.add(tempPermissionSetAssignment);
                                        // Keeps the map up to date. Mostly for test cases.
                                        mEmployeeTimesheetPermissionSetsByCombinedId.put((String) currentUser.Id + (String) PermissionSetId, tempPermissionSetAssignment);
                                    }
                                }
                            } else {
                                for (String permissionSetId : mTimesheetPermissionSetIdList) {
                                    // Check to see if the currentUser is NOT assigned the permissionSetId
                                    PermissionSetAssignment tempPermissionSetAssignment = mEmployeeTimesheetPermissionSetsByCombinedId.get((String) currentUser.Id + permissionSetId);
                                    if (tempPermissionSetAssignment != null) {
                                        // If the currentUser IS assigned the permissionSetId, then add it to the list of permission sets to remove
                                        permissionSetsToRemove.add(tempPermissionSetAssignment);
                                        // Keeps the map up to date. Mostly for test cases.
                                        mEmployeeTimesheetPermissionSetsByCombinedId.remove((String) currentUser.Id + permissionSetId);
                                    }
                                }
                            }
                        } else {
                            throw new COHException('COHUserHelper.updateTimesheetPermissions(): unable to create mEmployeeTimesheetPermissionSetsByCombinedID.');
                        }            
                    } else {
                        throw new COHException('COHUserHelper.updateTimesheetPermissions(): unable to create mTimesheetPermissionSetIdList.');
                    }
                }
            }
            // After iterating through all the users insert / delete the required PermissionSetAssignment objects
            try {
                insert permissionSetsToAdd;
                delete permissionSetsToremove;
            } catch (Exception e) {
                throw new COHException('COHUserHelper.updateTimeSheetPermissions(): Error saving permission set changes. Exception: ' + e.getMessage());
            }
        }
    }

    /*
     * Update the VP for all the subordinates of a user
     * 
     * @param userList       List of supervisor who were updated
     * 
     */
    public static void updateSubordinatesVP(List<Id> supervisorList) {
        List<User> supervisorReporteesList = new List<User>();
        List<User> reporteesToUpdate = new List<User>();
        
        if (COHUtil.isValidList(supervisorList)) {
            supervisorReporteesList = [SELECT id, VP_SVP_CTO__c, (SELECT id, VP_SVP_CTO__c FROM EmployeeMgr__r) FROM User WHERE id IN:supervisorList AND IsActive = true];
            for (User currentSupervisor : supervisorReporteesList) {
                if (COHUtil.isValidList(currentSupervisor.EmployeeMgr__r)) {
                    for (User currentReportee : currentSupervisor.EmployeeMgr__r) {
                        // testing--raymond tam
                        // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
                        //currentReportee.VP_SVP_CTO__c = (String.isNotEmpty(currentSupervisor.VP_SVP_CTO__c ) ? currentSupervisor.VP_SVP_CTO__c : currentReportee.VP_SVP_CTO__c);
                        if(String.isNotEmpty(currentSupervisor.VP_SVP_CTO__c)){
                            currentReportee.VP_SVP_CTO__c = currentSupervisor.VP_SVP_CTO__c;
                        }
                        reporteesToUpdate.add(currentReportee);
                    }
                }
            }

            if(COHUtil.isValidList(reporteesToUpdate)) {
                Database.update(reporteesToUpdate);
            }
        }
    }
    
    /*
     * Update the Director for all the subordinates of a user.
     * 
     * @param userList       List of supervisor who were updated
     * 
     */
    public static void updateSubordinatesDirector(List<Id> supervisorList) {
        List<User> supervisorReporteesList = new List<User>();
        List<User> reporteesToUpdate = new List<User>();
        
        if (COHUtil.isValidList(supervisorList)) {
            supervisorReporteesList = [SELECT id, Director__c, (SELECT id, Director__c FROM EmployeeMgr__r) FROM User WHERE id IN:supervisorList AND IsActive = true];
            for (User currentSupervisor : supervisorReporteesList) {
                if (COHUtil.isValidList(currentSupervisor.EmployeeMgr__r)) {
                    for (User currentReportee : currentSupervisor.EmployeeMgr__r) {
                        currentReportee.Director__c = (String.isNotEmpty(currentSupervisor.Director__c) ? currentSupervisor.Director__c : currentReportee.Director__c);
                        reporteesToUpdate.add(currentReportee);
                    }
                }
            }
            if (COHUtil.isValidList(reporteesToUpdate)) {
                Database.update(reporteesToUpdate);
            }
            
        }
    }
                
    /*
     * Update the supervisor for a user.  The code was originally taken from the UpdateSupervisor trigger.
     * 
     * @param userList       List of users whose supervisor has been updated
     * 
     */
    public static void updateSupervisor(List<User> userList) {
        if (COHUtil.isValidList(userList)) {
            for (User currentUser : userList) { 
                if (currentUser.IsActive && String.isNotBlank(currentUser.Supervisor_ID__c)) {
                    try {                                       
                        populateAllActiveEmployeesMaps();
                        User objEmployeeMgr = allActiveEmployeesByEmployeeNumberMap.get(currentUser.Supervisor_ID__c); 
                        if (objEmployeeMgr == null) {
                            return;
                        }
                        
                        // If user is own manager, do nothing. Only case should be CEO
                        if (currentUser.EmployeeNumber != objEmployeeMgr.EmployeeNumber) {
                            if(objEmployeeMgr != null) {
                                currentUser.Mgr__c = objEmployeeMgr.Id;
                                currentUser.Supervisor_ID__c = null;
                                currentUser.ManagerId = null;

                                // Need to populate VP list, and check to see if the current user is in the VP list. If so, skip assigning director and VP. 
                                // This needs to be handled this way, because someone in the VP list can report to someone else in the VP list, but we do not want them to show up in the VP/SVP/CTO fields
                                // 2019.02.18 - Tim Hughes
                                populateVPIds();
                                    
                                if (!VPIds.contains(currentUser.Id)) {
                                    currentUser.Director__c = null;
                                    User objEmployeeVP = FindDirectorVPRecursive(objEmployeeMgr);
                                    if(objEmployeeVP != null) {
                                        // testing--raymond tam
                                        // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                                      currentUser.VP_SVP_CTO__c = (String.isNotEmpty(objEmployeeVP.Id) ? objEmployeeVP.Id : currentUser.VP_SVP_CTO__c);
                                       if(String.isNotEmpty(objEmployeeVP.Id)){
                                           currentUser.VP_SVP_CTO__c = objEmployeeVP.Id;
                                       }
                                        User objEmployeeDirector = FindDirectorRecursive(objEmployeeMgr);
                                        if(objEmployeeDirector != null) {
                                            currentUser.Director__c = objEmployeeDirector.Id;
                                        } 
                                        else {
                                            currentUser.Director__c = null;
                                        }
                                    } 
                                    else {
                                        // testing--raymond tam
                                        // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                                        currentUser.VP_SVP_CTO__c = null;
                                    }
                                } 
                                else {
                                    currentUser.Director__c = null;
                                        // testing--raymond tam
                                        // Commented out as a temporary fix until the Peoplesoft feed passes in VP values.
//                                    currentUser.VP_SVP_CTO__c = null;
                                }
                            } 
                        }                             
                    }
                    catch (Exception e) {
                        system.debug('COHUserHelper.updateSupervisor() error = ' + e.getMessage()); 
                    }
                }
            } 
        }                   
    }
                
    /*
     * Recursive function to find the Director from a User. A User is a Director if their Mgr__c 
     * is either SVP_ITS or VP_CTO_INFRA (global variables). 
     * Base Case - Employee is a Director, otherwise call the function with the Employee as an argument.
     *
     * @param   Employee        A User object with the fields id, Name, ManagerId, Mgr__c and Title
     * 
     * @return                  If the Employee is a Director returns the Employee
     *                          If unable to determine Director returns null.
     */ 
    @TestVisible private static User FindDirectorRecursive(User Employee) {
        if (Employee == null) {
            return null;
        }
        populateAllActiveDirectorsSet();
        if (allActiveDirectorsSet == null) { // If allActiveDirectorsSet is still null then there are no active directors
            return null;
        }
        if(allActiveDirectorsSet.contains(Employee)) {
            return Employee;
        }
        else {
            if (Employee.Mgr__c != null) {
                populateAllActiveEmployeesMaps();
                User objEmployeeDirector = allActiveEmployeesByRecordIdMap.get(Employee.Mgr__c);
                
                if (objEmployeeDirector != null && objEmployeeDirector != Employee) {
                    return(FindDirectorRecursive(objEmployeeDirector));
                }
                else {
                    return null;
                }
            }
            else {
                return null;
            }
        }
    }
    
    /*
     * Recursive function to find a User's VP. The two VPs, SVP_ITS and VP_CTO_INFRA are global variables.   
     * Base Case - Employee is a VP, otherwise call the function with the Employee as an argument.     
     * 
     * @param   Employee        A User object with the fields id, Name, ManagerId, Mgr__c and Title
     * 
     * @return                  If the Employee is a VP returns the Employee
     *                          If unable to determine VP returns null.
     */ 
    @TestVisible private static User FindDirectorVPRecursive(User Employee) {
        if (Employee == null) {
            return null;
        }
        populateVPIds();
        if (VPIds == null) {
            return null;
        }
        if(VPIds.contains(Employee.Id)) {
            return Employee;
        }
        else {
            if(Employee.Mgr__c != null) {
                populateAllActiveEmployeesMaps();
                User objEmployeeVP = allActiveEmployeesByRecordIdMap.get(Employee.Mgr__c);
                
                if (objEmployeeVP != null && objEmployeeVP != Employee) {
                    return(FindDirectorVPRecursive(objEmployeeVP));                  
                }
                else {
                    return null;
                }
            }
            else {
                return null;
            }
        }  
    }
    
    /*
     * Function to populate the timesheetPermissionSetsList if it is null
     */
    private static void populateTimesheetPermissionSetIdList() {
        if (mTimesheetPermissionSetIdList == null) {
            mTimesheetPermissionSetIdList = new List<String>();
            List<COH_App_Configuration__c> configList = COHUtil.getConfigurationGroup(PERMSSION_SETS, ITS_TIMESHEET);
            if (COHUtil.isValidList(configList)) {
                for (COH_App_Configuration__c obj : configList) {
                    if (obj.Value_Type__c == 'String') {
                        // Casting it to Id ensures that it is a 18 Digit Id
                        mTimesheetPermissionSetIdList.add((Id)obj.Value__c);
                    }
                }
            }
        }
    }

    /*
     * Builds a query string that populates a Map containing the PermissionSetAssignment records of relevent Permission Sets
     * The map's key is the UserId concatenated with the PermissionSetId
     * Relevent Permission Sets should be stored in COH_App_Configuration objects
     * Current Relevent Permission Sets: Time / Effort, ITS Portfolio
     */
    private static void populateEmployeeTimesheetPermissionSetsByCombinedId() {
        if (mEmployeeTimesheetPermissionSetsByCombinedId == null) {
            populateTimesheetPermissionSetIdList();
            if (COHUtil.isValidList(mTimesheetPermissionSetIdList)) {
                String queryString = 'SELECT Id, AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE ';
                for (String permissionSet : mTimesheetPermissionSetIdList) {
                    queryString += 'PermissionSetId = \'' + permissionSet + '\' OR ';
                }
                // Removes trailing OR
                queryString = queryString.substring(0, queryString.length() - 4);

                try {
                    List<PermissionSetAssignment> tempList = Database.query(queryString);
                    mEmployeeTimesheetPermissionSetsByCombinedId = new Map<String, PermissionSetAssignment>();
                    for (PermissionSetAssignment permissionSet : tempList) {
                        mEmployeeTimesheetPermissionSetsByCombinedId.put((String) permissionSet.AssigneeId + (String) permissionSet.PermissionSetId, permissionSet);                        
                    }
                }    
                catch (Exception e) {
                    throw new COHException('COHUserHelper.populateEmployeeTimesheetPermissionSetsByCombinedId(): Error retrieving PermissionSetAssignment records. Exception: ' + e);
                }
            }
        }        
    }

    /*
     * Function to populate the allActiveEmployeesMap if it is null 
     */    
    private static void populateAllActiveEmployeesMaps() {
        if (allActiveEmployeesByRecordIdMap == null || allActiveEmployeesByEmployeeNumberMap == null) {
            allActiveEmployeesByEmployeeNumberMap = new Map<String, User>();
            allActiveEmployeesByRecordIdMap = new Map<Id, User>();
            
            List<User> allActiveEmployeesList = new List<User>([SELECT id, Name, ManagerId, Mgr__c, Title, EmployeeNumber FROM User WHERE IsActive = true AND EmployeeNumber != NULL]);
            if (COHUtil.isValidList(allActiveEmployeesList)) {
                for (User employee : allActiveEmployeesList) {
                    allActiveEmployeesByEmployeeNumberMap.put(employee.EmployeeNumber, employee);
                    allActiveEmployeesByRecordIdMap.put(employee.id, employee);
                }       
            }
        }
    }

    /*
     * Function to populate the allActiveDirectorsSet if it is null.
     * Finds the directors by finding all users whose Mgr__c == the entries in the COH_App_Configuration Group COHUserTriggerVPs
     * If the queryString is invalid, then VPIds remains null
     */  
    @TestVisible private static void populateAllActiveDirectorsSet() {
        if (allActiveDirectorsSet == null) {
            populateVPIds();
            if (VPIds != null) {
                try {
                    allActiveDirectorsSet = new Set<User>([SELECT Id, Name, ManagerId, Mgr__c, Title, EmployeeNumber FROM User WHERE IsActive = true AND Mgr__c IN :VPIds AND Id NOT IN :VPIds]);
                } 
                catch (Exception e) {
                    System.debug('COHUserHelper.populateAllActiveDirectorsSet(): There was an error populating the list of Directors: ' + e.getMessage());
                }       
            }     
        }
    }
    
    /*
     * Function to populate the VPIds Set should only be called if it is null.
     * The VPIds Set is populated from the COH_App_Configuration records with COH User Trigger VPs as their Configuration Group
     */ 
    @TestVisible private static void populateVPIds() {
        if (VPIds == null) {
            List<COH_App_Configuration__c> VPList = COHUtil.getConfigurationGroup('COH User Trigger VPs', 'COHUserTriggerVPs');
            
            if (COHUtil.isValidList(VPList))  {
                VPIds = new Set<Id>();
                for (COH_App_Configuration__c VP : VPList) {
                    VPIds.add(VP.Value__c);
                }
            }   
        }
    }    
    
    /*
     * Create an email message for an ITS Asset Request
     * 
     * @param userObj                       The User object for the new user's manager.
     * @param assetRequestObj       The ITS Asset Request object for the new user
     * @return                              The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createITSAssetRequestEmailMessage(User managerObj, ITSAssetRequest__c assetRequestObj) {
        
        Messaging.SingleEmailMessage email = null;
        if (managerObj != null && assetRequestObj != null) {
            String ownerEmailAddr = managerObj.Email;
            String textBody = buildEmailTextBody(managerObj, assetRequestObj);
            if (textBody != null) {
                email = new Messaging.SingleEmailMessage();
                if (String.isNotEmpty(mDefaultEmailAddress)) {
                    email.setReplyTo(mDefaultEmailAddress);
                    email.setToAddresses(new String[] {mDefaultEmailAddress}); 
                } else {
                    email.setReplyTo(ownerEmailAddr);
                    email.setToAddresses(new String[] {ownerEmailAddr}); 
                }
                email.setOrgWideEmailAddressId(mITSOrgWideEmailAddressID);
                email.Subject = 'IT Onboarding Request For: ' + assetRequestObj.Employee_Name__c + ',' + ' Email: ' + assetRequestObj.Position__c;
                email.setHTMLBody(textBody);
                email.setEmailPriority('Highest');
            }
        }
        return email;
    }
    
    /*
     * Create the email text body.
     * 
     * @param userObj                   The User object for person who will receive the email.
     * @param assetRequestObj           The ITS Asset Request object for the new user
     * @return                          The text of the email body.
     * 
     */
    private static String buildEmailTextBody(User userObj, ITSAssetRequest__c assetRequestObj) {
        String textBody = null;
        if (userObj != null && assetRequestObj != null) {

            String textBody0 = 'Dear Hiring Manager,';

            String textBody1 = '<br><br>Please complete the required equipment IT Onboarding Request Form prior to the start of your new employee.&nbsp';
            //FSalinas 20210818 Per Michael, userURL is hardcoded now
            String textBody2 = '<br><b>Note: IT requires <u>5 business days upon approval</u> for processing onboarding computer equipment.</b>';
            String userURL = 'https://coh.service-now.com/sp?id=sc_cat_item_guide&sys_id=d753f0e91bcf10106602b8061a4bcb87&sysparm_category=e80d9e321b4fd01004bc15ff034bcb4b';//URL.getSalesforceBaseURL().toExternalForm() + '/' + assetRequestObj.Id;
            String userURL2 = 'https://cityofhope--bmcservicedesk.na118.visual.force.com/apex/selfservicenew?tsid=02ud00000006mpo#/support/catalog/common'; 
            String textBody3 = '<br><br> <b><a href="' + userURL + '">' + 'Click Here To Open The Onboarding Request Form'  + '</a></b> ';
            
            String textBody4 = '<br><br>For system access requests: <b> <a href="' + userURL2 + '">' + 'Click Here to Open Self Service'  + '</a></b>' + '<br>';
            
            String textBody5 = ' • For Epic Access click on the New Epic Access Request' + '<br>';
            String textBody6 = ' • For other systems click the link “Submit AccessNET Requests” located in the menu to the left' + '<br>' ;
            
            String textBody7 = '<br><br>Sincerely,' + '<br>' + 'IT Department';
            
            
            textBody = textBody0 + textBody1 + textBody2 + textBody3 + textBody4 + textBody5 + textBody6 + textBody7;
        }    
        return textBody;
    }

    /*
     * Clears the mEmployeeTimesheetPermissionSetsByCombinedId map. Used in testing.
     */
    @TestVisible private static void clearEmployeeTimesheetPermissionSetsByCombinedId() {
        mEmployeeTimesheetPermissionSetsByCombinedId = null;
    }
}