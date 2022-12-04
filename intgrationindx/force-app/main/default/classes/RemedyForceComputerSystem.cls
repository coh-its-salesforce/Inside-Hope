/*
Author : CloudAction
Date : March 2020
Description : Apex Class to create Computer class in RF CMDB.
*/
public with sharing class RemedyForceComputerSystem {
    public RemedyForceComputerSystem() {}

    public void createRFComputerSystem(List<ServiceNowComputerSystem> allSNComputers){
        try{
                //Get the CLASS ID for BMC_ComputerSystem
                ID CMDBClassID = getRFComputerClassID();
                List<BMCServiceDesk__BMC_BaseElement__c>  existingRFComputerSystems = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                List<String> Names = new List<String>();
                for(ServiceNowComputerSystem svd : allSNComputers)
                {
                    Names.add(svd.Name);
                    System.debug('SNComputer names from API-' +svd.Name);
                }
                
                existingRFComputerSystems = getExistingRFComputerSystems(CMDBClassID, Names);

                List<BMCServiceDesk__BMC_BaseElement__c>  newRFComputerSystems = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                newRFComputerSystems = convertSNComputerToRF(allSNComputers, CMDBClassID, existingRFComputerSystems);

                updateOrInsert(existingRFComputerSystems, newRFComputerSystems); 

        }catch(Exception ex){
            System.debug('Error Occurred - ' +ex.getMessage());
            throw ex;
        }    
        return;  
    }


    private List<BMCServiceDesk__BMC_BaseElement__c> convertSNComputerToRF(List<ServiceNowComputerSystem> SNComputers, ID CMDBClassID, List<BMCServiceDesk__BMC_BaseElement__c>  existingRFComputerSystems){
        List<BMCServiceDesk__BMC_BaseElement__c>  RFComputers = new List<BMCServiceDesk__BMC_BaseElement__c>();
		String BronzeStrValue = 'Bronze';
        String SilverStrValue = 'Silver';
        boolean IsSilverExists = false;
        boolean IsBronzeExists = false;
        List<Schema.PicklistEntry> ple = getPicklistValues('BMCServiceDesk__BMC_BaseElement__c','Infinite_Support_Status__c');
        for( Schema.PicklistEntry pickListVal : ple){
            if (pickListVal.getLabel() == 'Silver' || pickListVal.getValue() == 'Silver'){
                SilverStrValue = pickListVal.getValue();
                IsSilverExists = true;
            }    
            if (pickListVal.getLabel() == 'Bronze' || pickListVal.getValue() == 'Bronze'){
                IsBronzeExists = true;
                BronzeStrValue = pickListVal.getValue();
            }
        } 
        
        
        for ( ServiceNowComputerSystem SNComp : SNComputers){
            if(!isExistsInRFCMDB(existingRFComputerSystems, SNComp.Name)){//If Computer already exists in RF, don't consider it
                BMCServiceDesk__BMC_BaseElement__c RFComp = new BMCServiceDesk__BMC_BaseElement__c();
                RFComp.BMCServiceDesk__CMDB_Class__c =  CMDBClassID;
                RFComp.BMCServiceDesk__Source__c = 'ServiceNow';
                RFComp.BMCServiceDesk__Name__c = (SNComp.Name == null ? '' : SNComp.Name );
                RFComp.BMCServiceDesk__UniqueCISourceID__c = RFComp.BMCServiceDesk__Name__c;
                RFComp.BMCServiceDesk__SerialNumber__c  =  (SNComp.Serial_number == null ? '' : SNComp.Serial_number );
               // RFComp.BMCServiceDesk__MACAddress__c  =  (SNComp.Ip_Address == null ? '' : SNComp.Ip_Address );
                RFComp.BMCServiceDesk__CITag__c = (SNComp.Asset_tag == null ? '' : SNComp.Asset_tag );
                RFComp.BMCServiceDesk__ManufacturerName__c  =  (SNComp.Manufacturer == null ? '' : SNComp.Manufacturer );
                RFComp.BMCServiceDesk__Model__c =  (SNComp.Model_id == null ? '' : SNComp.Model_id );
                //Custom Fields
                RFComp.ServiceNow_IP_address__c   =  (SNComp.Ip_Address == null ? '' : SNComp.Ip_Address );
                RFComp.ServiceNow_OS_Version__c =  (SNComp.Os_version == null ? '' : SNComp.Os_version );
                RFComp.ServiceNow_First_Discovered__c =  Datetime.valueOf(SNComp.First_discovered); 
                RFComp.ServiceNow_Last_Discovered__c  =  Datetime.valueOf(SNComp.Last_discovered);  
                RFComp.ServiceNow_Sys_updated_on__c  =  Datetime.valueOf(SNComp.Sys_updated_on);  
                
                if ( SNComp.Os_version == null  || SNComp.Os_version == ''){
                	if (IsBronzeExists == true )
                		RFComp.Infinite_Support_Status__c = BronzeStrValue;
            	}
            	else{
                	if (IsSilverExists == true )
                		RFComp.Infinite_Support_Status__c = SilverStrValue;
            	}
                
                System.debug('SNComputer names not in RF -' + SNComp.Name);

                RFComputers.add(RFComp);
            }
        }
        return RFComputers;
    }

    private void updateOrInsert(List<BMCServiceDesk__BMC_BaseElement__c> existingRFComputerSystems, List<BMCServiceDesk__BMC_BaseElement__c> newRFComputerSystems){
        List<BMCServiceDesk__BMC_BaseElement__c> insertDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();
        List<BMCServiceDesk__BMC_BaseElement__c> updateDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();

        for(BMCServiceDesk__BMC_BaseElement__c newDevice : newRFComputerSystems ){
            BMCServiceDesk__BMC_BaseElement__c existingDevice = getExistingDevice(existingRFComputerSystems, newDevice.BMCServiceDesk__Name__c);
            if (existingDevice != null ){
                if(hasChanged(existingDevice,  newDevice)){
                    System.debug('Device data updated');
                    if (newDevice.BMCServiceDesk__SerialNumber__c != null){
                        if (newDevice.BMCServiceDesk__SerialNumber__c <> '')
                            existingDevice.BMCServiceDesk__SerialNumber__c  =  newDevice.BMCServiceDesk__SerialNumber__c ;}
                    //existingDevice.BMCServiceDesk__MACAddress__c  =  newDevice.BMCServiceDesk__MACAddress__c;
                    
                    existingDevice.BMCServiceDesk__CITag__c = newDevice.BMCServiceDesk__CITag__c;
                    existingDevice.BMCServiceDesk__ManufacturerName__c  =  newDevice.BMCServiceDesk__ManufacturerName__c;
                    existingDevice.BMCServiceDesk__Model__c =  newDevice.BMCServiceDesk__Model__c;
                    //Custom Fields
                    existingDevice.ServiceNow_IP_address__c   =  newDevice.ServiceNow_IP_address__c;
                    existingDevice.ServiceNow_OS_Version__c =  newDevice.ServiceNow_OS_Version__c;
                    existingDevice.ServiceNow_First_Discovered__c =  newDevice.ServiceNow_First_Discovered__c; 
                    existingDevice.ServiceNow_Last_Discovered__c  =  newDevice.ServiceNow_Last_Discovered__c; 
                    existingDevice.ServiceNow_Sys_updated_on__c  =  Datetime.valueOf(newDevice.ServiceNow_Sys_updated_on__c);   
                    existingDevice.Infinite_Support_Status__c = newDevice.Infinite_Support_Status__c;
                    System.debug('Update computer in RF -' + newDevice.BMCServiceDesk__Name__c);
                    updateDevices.add(existingDevice);
                }
            }
            else {
                System.debug('New Device found -' + newDevice.BMCServiceDesk__Name__c);
                insertDevices.add(newDevice);
            }
        }
        System.debug('Total New Device found -' + insertDevices.size());
        if(insertDevices.size() > 0 ) {
            Database.SaveResult[] srList = Database.insert(insertDevices, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Computer.  ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                        System.debug('Error Computer, ID: ' + sr.getId());
                    }  
                }
            }            
        }
        

        if(updateDevices.size() > 0 ) Update updateDevices;

    }

    private BMCServiceDesk__BMC_BaseElement__c getExistingDevice(List<BMCServiceDesk__BMC_BaseElement__c> existingRFComputerSystems, String strName){
        BMCServiceDesk__BMC_BaseElement__c returnObj = new BMCServiceDesk__BMC_BaseElement__c();
        for(BMCServiceDesk__BMC_BaseElement__c device : existingRFComputerSystems){
            if(strName.equalsIgnoreCase(device.BMCServiceDesk__Name__c))
            {
                returnObj = device;
                return returnObj;
            }
        }
        return null;
    }

    private boolean hasChanged(BMCServiceDesk__BMC_BaseElement__c oldObject, BMCServiceDesk__BMC_BaseElement__c newObject){
        boolean hasObjectChanged = false;
        if (!(newObject.ServiceNow_Sys_Updated_On__c == oldObject.ServiceNow_Sys_Updated_On__c)){
            hasObjectChanged = true; 
            return hasObjectChanged;
        }
        return hasObjectChanged;
    }

    private List<BMCServiceDesk__BMC_BaseElement__c> getExistingRFComputerSystems(ID CMDBClassID, List<String> Names){
        List<BMCServiceDesk__BMC_BaseElement__c> allComputerSystems =  new List<BMCServiceDesk__BMC_BaseElement__c>();
        allComputerSystems = [SELECT ID, Name, BMCServiceDesk__Name__c,BMCServiceDesk__CMDB_Class__c,BMCServiceDesk__UniqueCISourceID__c,
                                     BMCServiceDesk__Source__c,BMCServiceDesk__InstanceID__c,BMCServiceDesk__SerialNumber__c,
                                     ServiceNow_IP_address__c,BMCServiceDesk__CITag__c,BMCServiceDesk__ManufacturerName__c,ServiceNow_Sys_updated_on__c,
                                     BMCServiceDesk__Model__c,ServiceNow_OS_Version__c,ServiceNow_First_Discovered__c,ServiceNow_Last_Discovered__c, Infinite_Support_Status__c 
                            FROM BMCServiceDesk__BMC_BaseElement__c
                            WHERE BMCServiceDesk__CMDB_Class__c = :CMDBClassID 
                    //      AND ( BMCServiceDesk__SerialNumber__c in :SerialNumbers OR BMCServiceDesk__Name__c in :Names];
                            AND  BMCServiceDesk__Name__c in :Names];
        for(BMCServiceDesk__BMC_BaseElement__c device : allComputerSystems){
            System.debug('Devices found in RF -' +device.BMCServiceDesk__Name__c);
        }
        return allComputerSystems;
    }

    private boolean isExistsInRFCMDB(List<BMCServiceDesk__BMC_BaseElement__c> allCMDBComputers, String strName){
        boolean exists = false;
        for(BMCServiceDesk__BMC_BaseElement__c device : allCMDBComputers){
            if ( device.BMCServiceDesk__Source__c <> null ){
                if((strName.equalsIgnoreCase(device.BMCServiceDesk__Name__c) ) &&
                    (!device.BMCServiceDesk__Source__c.equalsIgnoreCase('ServiceNow')) )
                {
                    exists = true;  
                    return exists;
                }
            }
        }
        return exists;
    }

    private ID getRFComputerClassID(){
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                     FROM BMCServiceDesk__CMDB_Class__c 
                                                    WHERE BMCServiceDesk__ClassID__c ='BMC_ComputerSystem'];
        if (CMDBClass != null )
            return CMDBClass.ID;    
        else
            return null;
    }
    
    private Static List<Schema.PicklistEntry> getPicklistValues(String objectName, String fieldName){
		Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
        } 
        return ple;
    }
}