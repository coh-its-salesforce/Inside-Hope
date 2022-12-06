/*
 * This class contains the methods for update the departments in the PeopleSoft__c 
 * object.  This should be called from the COHUpdatePeopleSoftDepartments class.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHUpdatePeopleSoftDepartmentsHelper {

    private static final String PEOPLESOFT = 'PeopleSoft__c';
    private static final String DEPARTMENT_COUNT_QUERY = 'select department, count(id) from user where isactive = true and department != null group by department';
    private static final String PS_RECORDS_QUERY = COHUtil.buildSelectAllSOQLStatement(PEOPLESOFT);
    private static final String AGR_DEPARTMENT ='department';
    private static final String AGR_DEPATMENT_COUNT ='expr0';
    
    /*
     * Default constructor.
     * 
     */
    public COHUpdatePeopleSoftDepartmentsHelper() {
    }
    
    /*
     * Update the departments and their respective user counts based on
     * the records from the User table.
     * 
     */
    public void updateDepartments() {
        
        // Map of the name of the Peoplesoft__c object to the actual object.
        Map<String, PeopleSoft__c> psDepartmentMap = new Map<String, PeopleSoft__c>();
        
        // Retrieve all Peoplesoft records
        List<PeopleSoft__c> allPSRecords = Database.query(PS_RECORDS_QUERY);
        if (COHUtil.isValidList(allPSRecords)) {
            // Load records into the map and reset the user count to 0
            for (PeopleSoft__c psObj : allPSRecords) {
                String deptName = psObj.Name;
                psObj.User_Count__c = 0;        // reset the count by default
                psDepartmentMap.put(deptName, psObj);
            }
        }
        
        // Retrieve all departments and count of employee records for those departments
        AggregateResult[] usersDeptCountReults = Database.query(DEPARTMENT_COUNT_QUERY);
        
        List<PeopleSoft__c> psObjectsList = new List<PeopleSoft__c>();

        // Update existing departments that have users and add new departments
        for (AggregateResult arObj : usersDeptCountReults) {
            String deptName = (String) arObj.get(AGR_DEPARTMENT);
            Integer userCount = (Integer) arObj.get(AGR_DEPATMENT_COUNT);
            PeopleSoft__c psObj = psDepartmentMap.get(deptName);
            if (psObj == null) {
                // insert new department
                PeopleSoft__c newPsObj = new PeopleSoft__c();
                newPsObj.Name = deptName;
                newPsObj.User_Count__c = userCount;
                psObjectsList.add(newPsObj);
            } else {
                // update existing department with a new user count
                psObj.User_Count__c = userCount;
                psObjectsList.add(psObj);
            }
        }            

        // Update all other existing departments that have no users
        List<PeopleSoft__c> allPSObjectList = psDepartmentMap.values();
        for (PeopleSoft__c psObj : allPSObjectList) {
            if (psObj.User_Count__c == 0) {
                psObjectsList.add(psObj);
            }
        }
        
        if (psObjectsList.size() > 0) {
            Database.upsert(psObjectsList);
        }
    }
    
}