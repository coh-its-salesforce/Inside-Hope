/*
Author : CloudAction
Date : July 2019
Description : Batch Class to fetch Medical devices from Armis and populate CMDB.
*/

global class ArmisCMDBBatch implements Database.Batchable<ArmisMedicalDevice>, Database.AllowsCallouts, Database.Stateful{
    global Iterable<ArmisMedicalDevice> start(Database.BatchableContext BC){
        return new ArmisDeviceIterable();
    }

    global void execute(Database.BatchableContext BC, List<ArmisMedicalDevice> allAccount){
       CMDBMedicalDevice  device = new CMDBMedicalDevice();
       device.createCMDBMedicalDevice(allAccount); 
    }

    global void finish(Database.BatchableContext BC){
      /*  AsyncApexJob a = [SELECT id, ApexClassId,
                       JobItemsProcessed, TotalJobItems,
                       NumberOfErrors, CreatedBy.Email,Status
                       FROM AsyncApexJob
                       WHERE id = :BC.getJobId()];
        if(a.Status == 'Failed')
        {
                // Send an email to the Apex job's submitter notifying of job completion.  
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'ritu.sah@cloudaction.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Medical device data import from Armis ');
                mail.setPlainTextBody('Error Occured while importing Medical devices from Armis system into CMDB. Pls. see the log files for more details.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }*/
    }
}