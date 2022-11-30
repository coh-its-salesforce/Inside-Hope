/*
Author : CloudAction
Date : March 2020
Description : Apex Class to create Computer class in RF CMDB.
*/
public with sharing class RemedyForceSoftware {
    public RemedyForceSoftware() {}
    public void createRFSoftware(List<ServiceNowSoftware> allSNSoftwares){
        try{
                //Get the CLASS ID for BMC_Product
                ID CMDBClassID = getRFProductClassID();
                List<String> SNNames = new List<String>();
                for(ServiceNowSoftware svd : allSNSoftwares)
                {
                    SNNames.add(svd.Name);
                }

                List<BMCServiceDesk__BMC_BaseElement__c>  existingRFsoftwares = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                existingRFsoftwares = getExistingRFSoftwares(CMDBClassID, SNNames);

                List<BMCServiceDesk__BMC_BaseElement__c>  newRFSoftwares = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                newRFSoftwares = convertSNSoftwareToRF(allSNSoftwares, CMDBClassID, existingRFsoftwares);

                updateOrInsert(existingRFsoftwares, newRFSoftwares); 

        }catch(Exception ex){
            System.debug('Error Occurred - ' +ex.getMessage());
            throw ex;
        }    
        return;  
    }

    private List<BMCServiceDesk__BMC_BaseElement__c> convertSNSoftwareToRF(List<ServiceNowSoftware> SNSoftwares, ID CMDBClassID, List<BMCServiceDesk__BMC_BaseElement__c>  existingRFSoftwares){
        List<BMCServiceDesk__BMC_BaseElement__c>  RFSoftwares = new List<BMCServiceDesk__BMC_BaseElement__c>();
        for ( ServiceNowSoftware SNSoft : SNSoftwares){
            //If Software already exists in RF, don't consider it
            if(!isExistsInRFCMDB(existingRFSoftwares, SNSoft.Name )){        
                BMCServiceDesk__BMC_BaseElement__c RFSoft = new BMCServiceDesk__BMC_BaseElement__c();
                String SysId = (SNSoft.Sys_id == null ? '' : SNSoft.Sys_id );
                RFSoft.BMCServiceDesk__CMDB_Class__c =  CMDBClassID;
                RFSoft.BMCServiceDesk__Source__c = 'ServiceNow';
                RFSoft.BMCServiceDesk__Name__c = (SNSoft.Name == null ? '' : SNSoft.Name );
                RFSoft.BMCServiceDesk__UniqueCISourceID__c = RFSoft.BMCServiceDesk__Name__c;
                RFSoft.BMCServiceDesk__ManufacturerName__c  =  (SNSoft.Manufacturer == null ? '' : SNSoft.Manufacturer );
                String SysClassName = (SNSoft.Sys_class_name == null ? '' : SNSoft.Sys_class_name );
                //Custom Fields
                RFSoftwares.add(RFSoft);
            }
        }
        return RFSoftwares;
    }

    private void updateOrInsert(List<BMCServiceDesk__BMC_BaseElement__c> existingRFSoftwares, List<BMCServiceDesk__BMC_BaseElement__c> newRFSoftwares){
        List<BMCServiceDesk__BMC_BaseElement__c> insertDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();
        List<BMCServiceDesk__BMC_BaseElement__c> updateDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();
        Map<String,BMCServiceDesk__BMC_BaseElement__c> devicesMap = new Map<String,BMCServiceDesk__BMC_BaseElement__c>();
        Map<String,BMCServiceDesk__BMC_BaseElement__c> devicesMapUpdate = new Map<String,BMCServiceDesk__BMC_BaseElement__c>();
        
        for(BMCServiceDesk__BMC_BaseElement__c newDevice : newRFSoftwares ){
            BMCServiceDesk__BMC_BaseElement__c existingDevice = getExistingDevice(existingRFSoftwares, newDevice.BMCServiceDesk__Name__c);
            if (existingDevice != null ){
                if(hasChanged(existingDevice,  newDevice)){
                    if (newDevice.BMCServiceDesk__ManufacturerName__c <> '' )
                        existingDevice.BMCServiceDesk__ManufacturerName__c  =  newDevice.BMCServiceDesk__ManufacturerName__c;
                        devicesMapUpdate.put(existingDevice.Id, existingDevice);
                        //updateDevices.add(existingDevice);
                }
            }
            else {
                devicesMap.put(newDevice.BMCServiceDesk__Name__c, newDevice);
            }
        }
        
        if(devicesMap.size() > 0 ) {
            insertDevices = devicesMap.values();
            System.debug('Total New Device found -' + insertDevices.size());
            Database.SaveResult[] srList = Database.insert(insertDevices, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Software. ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Software fields that affected this error: ' + err.getFields());
                    }
                        
                }
            }          
            //Insert insertDevices;
        }
        //if(updateDevices.size() > 0 ) Update updateDevices;
        if(devicesMapUpdate.size() > 0 ) {
            updateDevices = devicesMapUpdate.values();
            //for(BMCServiceDesk__BMC_BaseElement__c dv : updateDevices) System.debug('update' + dv);
            //Update updateDevices;
            Database.SaveResult[] srList = Database.update(updateDevices, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated Software. ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Software fields that affected update error: ' + err.getFields());
                    }
                        
                }
            }  
        }
    }

    private BMCServiceDesk__BMC_BaseElement__c getExistingDevice(List<BMCServiceDesk__BMC_BaseElement__c> existingSoftwares, String Name){
        BMCServiceDesk__BMC_BaseElement__c returnObj = new BMCServiceDesk__BMC_BaseElement__c();
        for(BMCServiceDesk__BMC_BaseElement__c device : existingSoftwares){
            if(Name.equalsIgnoreCase(device.BMCServiceDesk__Name__c))
            {
                returnObj = device;
                return returnObj;
            }
        }
        return null;
    }

    private boolean hasChanged(BMCServiceDesk__BMC_BaseElement__c oldObject, BMCServiceDesk__BMC_BaseElement__c newObject){
        boolean hasObjectChanged = false;
        if (!(newObject.BMCServiceDesk__ManufacturerName__c == oldObject.BMCServiceDesk__ManufacturerName__c)){
            hasObjectChanged = true; 
        }
        return hasObjectChanged;
    }

    private List<BMCServiceDesk__BMC_BaseElement__c> getExistingRFSoftwares(ID CMDBClassID, List<String> SNNames){
        List<BMCServiceDesk__BMC_BaseElement__c> allSoftwares =  new List<BMCServiceDesk__BMC_BaseElement__c>();
        allSoftwares = [SELECT ID, Name, BMCServiceDesk__Name__c,BMCServiceDesk__UniqueCISourceID__c,
                                     BMCServiceDesk__Source__c,BMCServiceDesk__InstanceID__c,
                                     BMCServiceDesk__ManufacturerName__c,
                                     BMCServiceDesk__Version_Number__c,ServiceNow_Install_Date__c,
                                     ServiceNow_Sys_Updated_On__c
                            FROM BMCServiceDesk__BMC_BaseElement__c
                            WHERE BMCServiceDesk__CMDB_Class__c = :CMDBClassID 
                            AND BMCServiceDesk__Name__c in :SNNames
                            ];

        return allSoftwares;
    }


    private boolean isExistsInRFCMDB(List<BMCServiceDesk__BMC_BaseElement__c> allCMDBSoftware, String Name){
        boolean exists = false;
        for(BMCServiceDesk__BMC_BaseElement__c device : allCMDBSoftware){
            if ( device.BMCServiceDesk__Source__c <> null ){
                if( (Name.equalsIgnoreCase(device.Name))  &&
                    (!device.BMCServiceDesk__Source__c.equalsIgnoreCase('ServiceNow')) )
                {
                    exists = true;
                    return exists;
                }
            }
        }
        return exists;
    }


    private ID getRFProductClassID(){
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                     FROM BMCServiceDesk__CMDB_Class__c 
                                                    WHERE BMCServiceDesk__ClassID__c ='BMC_Product'];
        if (CMDBClass != null )
            return CMDBClass.ID;    
        else
            return null;
    }
}