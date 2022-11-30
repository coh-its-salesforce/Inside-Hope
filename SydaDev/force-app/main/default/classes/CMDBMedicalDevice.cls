/*
Author : CloudAction
Date : July 2019
Description : Apex Class to get Medical Devices from Armis, process the data and save data into CMDB.
*/
public with sharing class CMDBMedicalDevice {
    public CMDBMedicalDevice() {
    }

    public List<ArmisMedicalDevice>  getArmisDevices(){
        List<ArmisMedicalDevice> allArmisDevices = new List<ArmisMedicalDevice>();
        List<Armis_Parameters__c> customDataList = new List<Armis_Parameters__c>();
        try{
            String armisDomain = 'https://cityofhope.armis.com';
            String key = '0d04f1582c979a59cb46453d79646eb5d602cc3f1cc29c1612fecb50ec6021cc';
            String SearchParameter = 'category:"Medical%20Therapeutic","Medical%20Diagnostic","Medical%20Support"';
            customDataList = getCustomSettingsFields();
            for(Armis_Parameters__c parameter : customDataList){
                if(parameter.Name.equalsIgnoreCase('ArmisDomain'))
                    armisDomain = parameter.Value__c;
                if(parameter.Name.equalsIgnoreCase('ConsumerKey'))
                    key = parameter.Value__c;
				if(parameter.Name.equalsIgnoreCase('SearchParameter'))
                    SearchParameter = parameter.Value__c;
            }
            allArmisDevices = ArmisRestAPI.callArmisAPI(armisDomain, key, SearchParameter);
            System.debug('Total devices from Armis-' + allArmisDevices.size());
        }catch(Exception ex){
            System.debug('Error Occurred - ' +ex.getMessage());
            throw ex;
        }
        return allArmisDevices;
    }

    public void createCMDBMedicalDevice(List<ArmisMedicalDevice> allNewArmisDevices){
        try{
                List<Armis_Parameters__c> customDataList = new List<Armis_Parameters__c>();
                customDataList = getCustomSettingsFields();

                ID CMDBClassID = getCMDBClassID();

                String armisBoundaryTags = 'Corporate,Guest,External\\Edge Devices,Vendor Networks,Off Network';
                String sourcePicklistValue ='Armis';
                for(Armis_Parameters__c parameter : customDataList){
                    if(parameter.Name.equalsIgnoreCase('ArmisBoundaryTags'))
                        armisBoundaryTags = parameter.Value__c;
                     if(parameter.Name.equalsIgnoreCase('SourcePicklistValue'))
                        sourcePicklistValue = parameter.Value__c;                       
                }

                List<BMCServiceDesk__BMC_BaseElement__c>  newCMDBMedicalDevices = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                newCMDBMedicalDevices = convertArmisDevicesToCMDB(allNewArmisDevices, CMDBClassID, armisBoundaryTags, sourcePicklistValue);

                List<BMCServiceDesk__BMC_BaseElement__c>  existingCMDBMedicalDevices = new List<BMCServiceDesk__BMC_BaseElement__c> ();
                existingCMDBMedicalDevices = getExistingMedicalDevices(CMDBClassID);

                updateOrInsertMedicalDevices(existingCMDBMedicalDevices, newCMDBMedicalDevices); 

        }catch(Exception ex){
            System.debug('Error Occurred - ' +ex.getMessage());
            throw ex;
        }    
        return;  
    }


    private void updateOrInsertMedicalDevices(List<BMCServiceDesk__BMC_BaseElement__c> existingCMDBMedicalDevices, List<BMCServiceDesk__BMC_BaseElement__c> newCMDBMedicalDevices){
        List<BMCServiceDesk__BMC_BaseElement__c> insertDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();
        List<BMCServiceDesk__BMC_BaseElement__c> updateDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();

        for(BMCServiceDesk__BMC_BaseElement__c newDevice : newCMDBMedicalDevices ){
            BMCServiceDesk__BMC_BaseElement__c existingDevice = getExistingDevice(existingCMDBMedicalDevices, newDevice.BMCServiceDesk__Name__c);
            if (existingDevice != null ){
                if(hasChanged(existingDevice,  newDevice)){
                    System.debug('Device data updated');
                    existingDevice.BMCServiceDesk__Category__c  = newDevice.BMCServiceDesk__Category__c;
                    //existingDevice.BMCServiceDesk__Name__c = newDevice.BMCServiceDesk__Name__c;
                    //existingDevice.BMCServiceDesk__CMDB_Class__c =  newDevice.BMCServiceDesk__CMDB_Class__c;
                    existingDevice.BMCServiceDesk__Category__c = newDevice.BMCServiceDesk__Category__c;
                    existingDevice.First_Seen_In_Armis__c = newDevice.First_Seen_In_Armis__c;
                    existingDevice.BMCServiceDesk__Network_Addresses__c = newDevice.BMCServiceDesk__Network_Addresses__c;
                    existingDevice.Last_Seen_In_Armis__c = newDevice.Last_Seen_In_Armis__c; 
                    existingDevice.BMCServiceDesk__ManufacturerName__c = newDevice.BMCServiceDesk__ManufacturerName__c;
                    existingDevice.BMCServiceDesk__Model__c = newDevice.BMCServiceDesk__Model__c;
                    existingDevice.Device_Name__c  = newDevice.Device_Name__c;
                    existingDevice.Operating_System__c = newDevice.Operating_System__c;
                    existingDevice.Risk_Level__c = newDevice.Risk_Level__c;
                    existingDevice.BMCServiceDesk__MACAddress__c = newDevice.BMCServiceDesk__MACAddress__c;
                    existingDevice.Device_Type__c  = newDevice.Device_Type__c;
                    existingDevice.Armis_User__c = newDevice.Armis_User__c;
                    existingDevice.Boundary__c = newDevice.Boundary__c;

                    existingDevice.BMCServiceDesk__CITag__c = newDevice.BMCServiceDesk__CITag__c;

                    existingDevice.Sensor_Name__c = newDevice.Sensor_Name__c;
                    existingDevice.BMCServiceDesk__Site__c = newDevice.BMCServiceDesk__Site__c;
                    updateDevices.add(existingDevice);
                }
            }
            else {
                System.debug('New Device found -' + newDevice.BMCServiceDesk__Name__c);
                insertDevices.add(newDevice);
            }
        }

        if(insertDevices.size() > 0 ) Insert insertDevices;
        if(updateDevices.size() > 0 ) Update updateDevices;

    }
    

    private List<BMCServiceDesk__BMC_BaseElement__c> getExistingMedicalDevices(ID CMDBClassID){
        List<BMCServiceDesk__BMC_BaseElement__c> allMedicalDevices =  new List<BMCServiceDesk__BMC_BaseElement__c>();
        allMedicalDevices = [SELECT ID, name, BMCServiceDesk__Name__c,BMCServiceDesk__CMDB_Class__c,
                                    BMCServiceDesk__Category__c,First_Seen_In_Armis__c,BMCServiceDesk__Network_Addresses__c,
                                    Last_Seen_In_Armis__c,BMCServiceDesk__ManufacturerName__c,BMCServiceDesk__Model__c,
                                    Device_Name__c,Operating_System__c,Risk_Level__c,Device_Type__c,Armis_User__c,Boundary__c,
                                    BMCServiceDesk__MACAddress__c,BMCServiceDesk__CITag__c,Sensor_Name__c,BMCServiceDesk__Site__c
                            FROM BMCServiceDesk__BMC_BaseElement__c
                            WHERE BMCServiceDesk__CMDB_Class__c = :CMDBClassID];

        return allMedicalDevices;
    }

    private List<BMCServiceDesk__BMC_BaseElement__c> convertArmisDevicesToCMDB(List<ArmisMedicalDevice> AllDevices, ID CMDBClassID, String ExistingTags, String sourcePicklistValue){
        List<BMCServiceDesk__BMC_BaseElement__c>  CMDBMedicalDevices = new List<BMCServiceDesk__BMC_BaseElement__c>();
        for ( ArmisMedicalDevice ArmisDevice : AllDevices){
            BMCServiceDesk__BMC_BaseElement__c CMDBDevice = new BMCServiceDesk__BMC_BaseElement__c();
            
            //CMDBDevice.BMCServiceDesk__Name__c = (ArmisDevice.Name == null ? '' : ArmisDevice.Name +' - ') + ArmisDevice.Id;
            CMDBDevice.BMCServiceDesk__Name__c = ArmisDevice.Id;
            CMDBDevice.BMCServiceDesk__CMDB_Class__c =  CMDBClassID;

            CMDBDevice.BMCServiceDesk__Category__c = (ArmisDevice.Category == null ? '' : ArmisDevice.Category);
            CMDBDevice.First_Seen_In_Armis__c = Datetime.valueOf(ArmisDevice.FirstSeen.replace('T', ' '));

            CMDBDevice.BMCServiceDesk__Network_Addresses__c = (ArmisDevice.IpAddress == null ? '' : ArmisDevice.IpAddress);
            CMDBDevice.Last_Seen_In_Armis__c = Datetime.valueOf(ArmisDevice.LastSeen.replace('T', ' ')); 

            CMDBDevice.BMCServiceDesk__ManufacturerName__c = (ArmisDevice.Manufacturer == null ? '' : ArmisDevice.Manufacturer);
            CMDBDevice.BMCServiceDesk__Model__c = (ArmisDevice.Model == null ? '' : ArmisDevice.Model);
            CMDBDevice.Device_Name__c  = (ArmisDevice.Name == null ? ArmisDevice.Model : ArmisDevice.Name );
            CMDBDevice.Operating_System__c = (ArmisDevice.OperatingSystem == null ? '' : ArmisDevice.OperatingSystem) + ' ' 
                                             + (ArmisDevice.OperatingSystemVersion == null ? '' : ArmisDevice.OperatingSystemVersion );
            CMDBDevice.Risk_Level__c = (ArmisDevice.RiskLevel == null ? '' : ArmisDevice.RiskLevel);
            Integer risklevel = 0;
            if(String.isNotBlank(CMDBDevice.Risk_Level__c)) {
                risklevel = Integer.valueOf(CMDBDevice.Risk_Level__c);
            }
            
            if(riskLevel >=1 && riskLevel <=3)
                CMDBDevice.Risk_Level__c = 'Low';
            else if(riskLevel >=4 && riskLevel <=7)
                CMDBDevice.Risk_Level__c = 'Medium';
            if(riskLevel >=8 && riskLevel <=10)
                CMDBDevice.Risk_Level__c = 'High';
                
            CMDBDevice.BMCServiceDesk__MACAddress__c = (ArmisDevice.MacAddress == null ? '' : ArmisDevice.MacAddress);
            
            CMDBDevice.Device_Type__c  = (ArmisDevice.Type == null ? '' : ArmisDevice.Type);
            CMDBDevice.Armis_User__c = (ArmisDevice.user == null ? '' : ArmisDevice.user);
            CMDBDevice.Boundary__c = GetBoundryFromArmisTag(ArmisDevice.Tags, ExistingTags);
            List<String> tempTags = ArmisDevice.Tags;
            
            CMDBDevice.BMCServiceDesk__CITag__c = string.join(tempTags,',');
            CMDBDevice.BMCServiceDesk__Site__c = ''; // populate it with location from Armis
            CMDBDevice.Sensor_Name__c = ''; //populate with Sensor name from Armis

            CMDBDevice.BMCServiceDesk__Source__c = sourcePicklistValue;
            //CMDBDevice.BMCServiceDesk__UniqueCISourceID__c  = (ArmisDevice.Name == null ? '' : ArmisDevice.Name +' - ') + ArmisDevice.Id;
            
            CMDBDevice.BMCServiceDesk__Stage__c = '';
            CMDBMedicalDevices.add(CMDBDevice);
        }
        return CMDBMedicalDevices;
    }

    private String getBoundryFromArmisTag(List<String> armisTags, String ExistingTags){
        String Boundary = '';
        for (String tag : armisTags){
            if (ExistingTags.containsIgnoreCase(tag))
                Boundary = tag + ',';
        }
        Boundary = Boundary.removeEnd(',');
        return Boundary;
    }


    private ID getCMDBClassID(){
        BMCServiceDesk__CMDB_Class__c CMDBClass = [SELECT ID, BMCServiceDesk__ClassName__c 
                                                     FROM BMCServiceDesk__CMDB_Class__c 
                                                    WHERE BMCServiceDesk__ClassID__c ='BMC_Medical'];
        if (CMDBClass != null )
            return CMDBClass.ID;    
        else
            return null;
    }

    private boolean isExistsInCMDB(List<BMCServiceDesk__BMC_BaseElement__c> allCMDBMedicalDevices, String ArmisID){
        boolean exists = false;
        for(BMCServiceDesk__BMC_BaseElement__c device : allCMDBMedicalDevices){
            if(ArmisID.equalsIgnoreCase(device.BMCServiceDesk__Name__c))
            {
                exists = true;
                return exists;
            }
        }
        return exists;
    }
    
    private boolean hasChanged(BMCServiceDesk__BMC_BaseElement__c oldObject, BMCServiceDesk__BMC_BaseElement__c newObject){
        boolean hasObjectChanged = false;
        if (isNotEqual(oldObject.BMCServiceDesk__Category__c, newObject.BMCServiceDesk__Category__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (!(oldObject.First_Seen_In_Armis__c == newObject.First_Seen_In_Armis__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.BMCServiceDesk__Network_Addresses__c, newObject.BMCServiceDesk__Network_Addresses__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (!(oldObject.Last_Seen_In_Armis__c == newObject.Last_Seen_In_Armis__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.BMCServiceDesk__ManufacturerName__c, newObject.BMCServiceDesk__ManufacturerName__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.BMCServiceDesk__Model__c, newObject.BMCServiceDesk__Model__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Device_Name__c, newObject.Device_Name__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Operating_System__c, newObject.Operating_System__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Risk_Level__c, newObject.Risk_Level__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.BMCServiceDesk__MACAddress__c, newObject.BMCServiceDesk__MACAddress__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Device_Type__c, newObject.Device_Type__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Armis_User__c, newObject.Armis_User__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Boundary__c, newObject.Boundary__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.BMCServiceDesk__CITag__c, newObject.BMCServiceDesk__CITag__c)) { hasObjectChanged = true; return hasObjectChanged;}
        if (isNotEqual(oldObject.Sensor_Name__c, newObject.Sensor_Name__c)) { hasObjectChanged = true; return hasObjectChanged;}        
        if (isNotEqual(oldObject.BMCServiceDesk__Site__c, newObject.BMCServiceDesk__Site__c)) { hasObjectChanged = true; return hasObjectChanged;}
        return hasObjectChanged;
    }

    private boolean isNotEqual(String oldValue, String newValue){
        if (oldValue == null) oldValue = '';
        if (newValue == null) newValue = '';
        if (!oldValue.equalsIgnoreCase(newValue)) 
            return true;
        return false;      
    }

    private BMCServiceDesk__BMC_BaseElement__c getExistingDevice(List<BMCServiceDesk__BMC_BaseElement__c> allCMDBMedicalDevices, String armisID){
        BMCServiceDesk__BMC_BaseElement__c returnObj = new BMCServiceDesk__BMC_BaseElement__c();
        for(BMCServiceDesk__BMC_BaseElement__c device : allCMDBMedicalDevices){
            if(armisID.equalsIgnoreCase(device.BMCServiceDesk__Name__c))
            {
                returnObj = device;
                return returnObj;
            }
        }
        return null;
    }

    private Static List<Armis_Parameters__c> getCustomSettingsFields(){
        List<Armis_Parameters__c> fieldsList = new List<Armis_Parameters__c>();
        Map<String, Armis_Parameters__c> armisDataMap = Armis_Parameters__c.getAll();
        fieldsList = armisDataMap.values();
        return fieldsList;
    }

}