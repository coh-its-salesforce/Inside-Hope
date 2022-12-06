/* 
* Larry Kiang
* City of Hope 
* Copyright (c) 2019 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/

public class COHVisaHelper {
    private static String VisaObject = 'Visa__c';
    private static String InternationalServices = 'International Services';
    //This method will deactivate past visas with the same employee. 08/10/2019
    public static void scanVisasToDeactivate(List<Visa__c> visa){ 
        if(ITSIntakeTriggerCheckRecursive.isFirstTimeForVisa)
        {
            ITSIntakeTriggerCheckRecursive.isFirstTimeForVisa = false;
            DateTime Now = DateTime.now();
            Id InternationalServicesRecId = COHUtil.getRecordType(VisaObject, InternationalServices);
            
            List <Id> employeeIdsInVisas = new List <Id>();
            List <DateTime> visaCreatedDate = new List <DateTime>();
            for (Visa__c checkEmployee:visa){
                if(checkEmployee.Employee__c != null && 
                   checkEmployee.Status__c == 'Completed' && 
                   checkEmployee.Active__c == true &&
                   (checkEmployee.DS_2019_Valid_To__c != null || 
                    checkEmployee.I_20_Valid_To__c != null || 
                    checkEmployee.Initial_F_1_OPT_Valid_To__c != null || 
                    checkEmployee.F_1_STEM_OPT_Valid_To__c != null ||
                    checkEmployee.I_797_Valid_To__c != null))
                {
                    employeeIdsInVisas.add(checkEmployee.Employee__c);
                    visaCreatedDate.add(checkEmployee.CreatedDate);
                }
            }
            if(employeeIdsInVisas.size() > 0)
            {
                List <Visa__c> visaNoLongerCurrent = [select Id, 
                                                      Name,
                                                      Active__c,
                                                      Date_Visa_was_Deactivated__c, 
                                                      Employee__c, 
                                                      Createddate,
                                                      RecordType.name from 
                                                      Visa__c where Createddate < :visaCreatedDate and 
                                                      Employee__c =:employeeIdsInVisas and 
                                                      RecordType.Id =:InternationalServicesRecId and
                                                      Active__c = true];
                List <Visa__c> visaNoLongerCurrentUpdateList = new List <Visa__c>();
                if(visaNoLongerCurrent.size()>0)
                {
                    for(Visa__c visaRecord : visaNoLongerCurrent)
                    {
                        visaRecord.Active__c = false;
                        visaRecord.Date_Visa_was_Deactivated__c = now;
                        visaRecord.Add_ISSO_Notes__c = 'Record Deactivated as record has been superceded by a new record with the same employee.';
                        visaNoLongerCurrentUpdateList.add(visaRecord); 
                    }
                }
                update visaNoLongerCurrentUpdateList;
            }
        }
    }
}