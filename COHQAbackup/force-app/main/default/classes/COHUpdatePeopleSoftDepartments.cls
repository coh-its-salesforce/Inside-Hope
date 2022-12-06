/*
 * This class contains the implements the Schedulable interface in order to
 * run scheduled jobs to update the departments in the PeopleSoft__c object. 
 * It should be run from the Apex job scheduler.
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
public class COHUpdatePeopleSoftDepartments implements Schedulable {
   public void execute(SchedulableContext SC) {
       COHUpdatePeopleSoftDepartmentsHelper cupsdh = new COHUpdatePeopleSoftDepartmentsHelper();
       cupsdh.updateDepartments();
   }
}