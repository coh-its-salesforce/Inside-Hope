/*
* This trigger processes User objects.
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
trigger COHUserTrigger on User (before update, after insert, before insert, after update) {
    
    private static String ITS_ASSET_REQUEST_APPLICATION = 'ITS Asset Request';
    
    // Used to restrict trigger operations to certain departments.  The list
    // is delimited by the DEPARTMENT_DELIMITER.  
    // This allows for a partial production roll-out for testing.  In full 
    // production mode, the list of departments should be empty.
    private static String RESTRICTED_DEPARTMENTS = 'Restricted Departments';
    private static String DEPARTMENT_DELIMITER = 'Department Delimiter';
    PRIVATE STATIC FINAL STRING CUSTOMER_COMMUNITY_PLUS = 'Customer Community Plus';
    
    private static List<String> mRestrictedDeptList = new List<String>();
    private static List<User> mUpdateSupervisorList = new List<User>();
    private static List<Id> mCreateITSAssetRequestList = new List<Id>();
    private static List<User> mUpdateTimesheetPermissions = new List<User>();
    private static List<Id> mUpdateVPList = new List<Id>();
    private static List<Id> mUpdateDirectorList = new List<Id>();
    
    // Setup configuration for After Insert trigger
    if (Trigger.isInsert && Trigger.isAfter) {
        // If departments are listed in the restrictedDepartmentsStr, then only Users who
        // belong to those departments should be processed for ITS_Asset_Request__c objects.
        String restrictedDepartmentsStr = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, RESTRICTED_DEPARTMENTS);
        if (String.isNotBlank(restrictedDepartmentsStr)) {
            String departmentDelimiter = (String) COHUtil.getConfigurationValue(ITS_ASSET_REQUEST_APPLICATION, DEPARTMENT_DELIMITER);
            mRestrictedDeptList = restrictedDepartmentsStr.split(departmentDelimiter);
        }
       
    }
   
    if(trigger.isInsert && trigger.isBefore){
        UserTriggerHelper.checkManagerFieldUpdate(Trigger.New, null);
    }
     
    if(trigger.isUpdate && trigger.isBefore){
        UserTriggerHelper.checkManagerFieldUpdate(Trigger.New, Trigger.oldMap);
    }
    
    
    for (User usrObj : Trigger.new) {
        if ((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore) {
            // Update the supervisors
            mUpdateSupervisorList.add(usrObj);
            // This checks to see if the User's ITS_Timesheet__c field has been updated.
            // If it has, then it will update the Timesheet permissions
            if (Trigger.isUpdate && Trigger.oldMap.get(usrObj.Id).ITS_Timesheet__c != usrObj.ITS_Timesheet__c) {
                mUpdateTimesheetPermissions.add(usrObj);
            }
        } else if (Trigger.isInsert && Trigger.isAfter) {
            // Create new ITSAssetRequest__c objects.  The object IDs must be passed in because 
            // this will be handled by a @future method.  
            String deptName = usrObj.Department;
            if (isValidDepartment(deptName) && usrObj.Salesforce_Licence_Type__c != CUSTOMER_COMMUNITY_PLUS) {
                mCreateITSAssetRequestList.add(usrObj.Id);                              
            }
            // Checks to see if the newly inserted user needs the ITS Timesheet permission sets.
            // This will be checked in the function, but a newly created user will never need to have
            // their permissions removed, so I just do it here to avoid unecessary SOQL queries.
            if (usrObj.ITS_Timesheet__c == true) {
                mUpdateTimesheetPermissions.add(usrObj);
            }          
        }
    }
    if (COHUtil.isValidList(mUpdateSupervisorList)) {
        COHUserHelper.updateSupervisor(mUpdateSupervisorList);
    }
    if (COHUtil.isValidList(mCreateITSAssetRequestList) && globalStaticVar.executeforbatch) {
        COHUserHelper.processNewUsers(mCreateITSAssetRequestList);
    }
    if (COHUtil.isValidList(mUpdateTimesheetPermissions)) {
        COHUserHelper.updateTimesheetPermissions(mUpdateTimesheetPermissions);
    }
    
    // This has to be done after updateSupervisor is called because updateSupervisor may update the User's VP/Director
    if (Trigger.isUpdate && Trigger.isAfter) {    
        for (User usrObj : Trigger.new) {
            // Check if the VP has changed. If so, then update the VP for all the 
            // user's subordinates.            
            if (Trigger.oldMap.get(usrObj.Id).vp_svp_cto__c != usrObj.vp_svp_cto__c) {
                mUpdateVPList.add(usrObj.Id);
            }
            // Check if the Director has changed.  If so, then update the Director for all the 
            // user's subordinates.
            if (Trigger.oldMap.get(usrObj.Id).director__c != usrObj.director__c) {
                mUpdateDirectorList.add(usrObj.Id);
            }
        }
    }
    if (COHUtil.isValidList(mUpdateVPList)) {
        COHUserHelper.updateSubordinatesVP(mUpdateVPList);
    }
    if (COHUtil.isValidList(mUpdateDirectorList)) {
        COHUserHelper.updateSubordinatesDirector(mUpdateDirectorList);
    }
    
    
    /*
    * Checks if a department name is valid for creating an ITS_Asset_Request__c object.
    * If the department name is blank, empty, or null, it is considered valid.
    * 
    * @param userDeptName  Name of the user's department.
    * @returns             true if the department is valid, false otherwise.
    * 
    */
    private static Boolean isValidDepartment(String userDeptName) {
        if (String.isBlank(userDeptName) || !COHUtil.isValidList(mRestrictedDeptList)) {
            return true;
        }
        Boolean retVal = false;
        for (String departmentName : mRestrictedDeptList) {
            if (userDeptName.contains(departmentName)) {
                retVal = true;
                break;
            }
        }
        return retVal;
    }
}