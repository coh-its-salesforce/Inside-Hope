/*
* This class contains the methods for handling trigger events for Account objects.
* 
* Raymond Tam
* City of Hope
* Copyright (c) 2015
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  Test Ckass:NPSProcessAccountTester
*/
public class COHAccountHelper {
    
    /*
* This method handles all trigger calls for the Account object except as noted above.
* 
*/
    public static void processAccounts() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isUpdate) {
                // Updates the status on completed accounts
                NPSProcessAccountUtil.processCompletedAccounts(Trigger.new);
                
            }
        }
    }
    
    
    public static void afterInsert(List<Account> newList){
        for(Account inx : newList){
            String address = (inx.Patient_Street1__c!=null?inx.Patient_Street1__c:'')+(inx.Patient_City__c!=null?inx.Patient_City__c:'')+(inx.COH_PA_State__c!=null?inx.COH_PA_State__c:'')+(inx.COH_PA_Country__c!=null?inx.COH_PA_Country__c:'')+(inx.Patient_Postal_Code__c!=null?inx.Patient_Postal_Code__c:'');
            getCordinates(address,inx.Id,'Account');
        }
        
    }
    
    public static void beforeUpdate(List<Account> newList,Map<Id,Account> oldMap){
        for(Account inx : newList){
            if(inx.Patient_Street1__c != oldMap.get(inx.Id).Patient_Street1__c 
               || inx.Patient_City__c != oldMap.get(inx.Id).Patient_City__c
               || inx.COH_PA_State__c != oldMap.get(inx.Id).COH_PA_State__c
               || inx.COH_PA_Country__c != oldMap.get(inx.Id).COH_PA_Country__c
               || inx.Patient_Postal_Code__c != oldMap.get(inx.Id).Patient_Postal_Code__c){
                   String address = (inx.Patient_Street1__c!=null?inx.Patient_Street1__c:'')+(inx.Patient_City__c!=null?inx.Patient_City__c:'')+(inx.COH_PA_State__c!=null?inx.COH_PA_State__c:'')+(inx.COH_PA_Country__c!=null?inx.COH_PA_Country__c:'')+(inx.Patient_Postal_Code__c!=null?inx.Patient_Postal_Code__c:'');
                   getCordinates(address,inx.Id,'Account');
               }
        }
    }
    
    @future(callout=true)
    public static void getCordinates(String address, Id recordId,String objectName) {
        //TestMockAddressApiResponse instance = new TestMockAddressApiResponse();
        //Test.setMock(HttpCalloutMock.class,instance);
        list<String> resList = new list<String>();
        //String endpoint = 'https://maps.googleapis.com/maps/api/distancematrix/json?';
        String apiKey = System.label.COH_Google_Api_Distance_Key ;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String encodedAddress = EncodingUtil.URLEncode(address,'UTF-8');
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+encodedAddress+'&key='+apiKey);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        System.debug('response:--> ' + res.getBody());
        
        system.debug('res.getStatusCode()::'+res.getStatusCode());
        if(res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            system.debug('response::'+res.getBody());
            double lat = null;
            double lon = null; 
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) { 
                    parser.nextToken(); 
                    while (parser.nextToken() != JSONToken.END_OBJECT) {
                        String txt = parser.getText();
                        parser.nextToken();
                        if(txt == 'lat') { 
                            lat = parser.getDoubleValue(); 
                        } 
                        else if(txt == 'lng') {
                            lon = parser.getDoubleValue();
                        }
                    } 
                } 
            } 
            
            if(objectName == 'Account'){
                Account rec = new Account();
                rec.Id = recordId;
                rec.Patient_Location__Latitude__s = lat;
                rec.Patient_Location__Longitude__s = lon;
                system.debug('Latitude'+lat);
                system.debug('Longitude'+lon);
                update rec;
            }
            if(objectName == 'Lead'){
                Lead rec= new Lead();
                rec.Id = recordId;
                rec.Latitude = lat;
                rec.Longitude = lon;
                update rec;
            }
            //return new Cooridinates(lat, lon);
        } 
        else {
            //return null; 
        } 
    }
}