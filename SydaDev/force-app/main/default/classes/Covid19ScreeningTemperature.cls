@RestResource(urlMapping='/temperaturecheck/*')
global with sharing class Covid19ScreeningTemperature {

  @HttpPost
    global static COVID_19_Employee_Screening__c doPost(String COVID_19_Employee_Screening_Id,
        Double temp, String DeviceName) {
        Location_Check_In__c LocCkIn = new Location_Check_In__c();
        LocCkIn.COVID_19_Employee_Screening__c = COVID_19_Employee_Screening_Id;
        LocCkIn.PersonTemperature__c = temp;
        LocCkIn.DeviceName__c = DeviceName;
        insert LocCkIn;
        String covidId = COVID_19_Employee_Screening_Id;
        COVID_19_Employee_Screening__c result =  [SELECT Employee_Number__c,Employee__r.Name,Pass_Valid_Until__c,Status__c, QR_Check_In__c 
                        FROM COVID_19_Employee_Screening__c
                        WHERE Id = :covidId];
        return result;
        
    }
}