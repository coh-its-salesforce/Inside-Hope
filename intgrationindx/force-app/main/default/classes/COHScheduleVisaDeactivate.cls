global class COHScheduleVisaDeactivate implements Schedulable{

    /* 
* Larry Kiang
* City of Hope 
* Copyright (c) 2019 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/	
    
    //This method will deactivate Visas where the employee contains a deactive user account. 08/10/2019
    global void execute (SchedulableContext ctx){
        DateTime Now = dateTime.now(); 
        list <visa__c> visastoUpdate = new list <visa__c>();
        list <visa__c> visastoDeactivate = [select id,  
                                            name, 
                                            active__c,
                                            Date_Visa_was_Deactivated__c from 
                                            visa__c WHERE 
                                            ((DS_2019_Valid_To__c < today or 
                                              //Maximum_Validity_Date_of_J_1__c < today or 
                                              I_20_Valid_To__c < today or 
                                              Initial_F_1_OPT_Valid_To__c < today or 
                                              F_1_STEM_OPT_Valid_To__c < today or
                                              I_797_Valid_To__c < today //or 
                                              /*Period_of_H_L_Valid_To__c < today*/) and 
                                             active__c = true)];
        List<String> visaRecordsDeactivated = new List<String>();
        
        if(visastoDeactivate.size() >= 1){
            for(visa__c v : visastoDeactivate){
                v.active__c = false;
                v.Date_Visa_was_Deactivated__c = now;
                v.Add_ISSO_Notes__c = 'Record Deactivated due to Visa Expiration.';
                visastoUpdate.add(v);        
                visaRecordsDeactivated.add(v.Name);
            }
            update visastoUpdate;
            system.debug(visastoDeactivate.size() + ' Visa(s) has/have been deactivated. The following records were deactivated: '+ visaRecordsDeactivated); 
        }
    }
}