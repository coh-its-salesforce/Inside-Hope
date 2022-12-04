/*
Author : CloudAction
Date : July 2019
Description : Armis Device Iterable Class to be called by Batch process to fetch Medical
              Devices information from Armis by calling Armis WebAPIs.
*/
global class ArmisDeviceIterable implements Iterable<ArmisMedicalDevice>, Iterator<ArmisMedicalDevice>{ 
    List<ArmisMedicalDevice> devices {get; set;} 
    Integer i {get; set;} 

    public ArmisDeviceIterable(){ 
        CMDBMedicalDevice armisAPI = new CMDBMedicalDevice();
        devices = armisAPI.getArmisDevices();
        i = 0; 
    }   

    public Iterator<ArmisMedicalDevice> iterator() { 
        return this; 
    }

    global boolean hasNext(){ 
        if(i >= devices.size()) 
            return false; 
        else 
            return true; 
    }
        
    global ArmisMedicalDevice next(){ 
        if(i == devices.size()){ i++; return null;} 
        i=i+1; 
        return devices[i-1]; 
    } 
}