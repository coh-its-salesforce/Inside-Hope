/*
Author : CloudAction
Date : July 2019
Description : Apex Class to call Armis web APIS to fetch Medical devices data.
*/
public with sharing class ArmisRestAPI {
    public ArmisRestAPI() {}

    public static List<ArmisMedicalDevice> callArmisAPI(String ArmisDomainName, String SecretKey, String SearchParam){
        String URL = ArmisDomainName +'/api/v1/access_token/?secret_key='+SecretKey;
        Integer noOfRecords = 100;
        String accessToken  = GetAccessToken(URL);
        List<ArmisMedicalDevice> ArmisDevices = new List<ArmisMedicalDevice>();
        List<ArmisMedicalDevice> AllArmisDevices = new List<ArmisMedicalDevice>();

        Integer count = 0;
        Integer fromCount = 1;
        String responseString  =  callAPI( ArmisDomainName, accessToken, noOfRecords, 0, SearchParam);
        if(!responseString.equalsIgnoreCase('Error') )
        {
            count = getRecordCound(responseString);
            ArmisDevices = ParseResponse(responseString);
            AllArmisDevices.addAll(ArmisDevices);
            while (count == noOfRecords)         
            {
                ArmisDevices = new List<ArmisMedicalDevice>();
                fromCount = fromCount + noOfRecords;
                responseString  =  callAPI( ArmisDomainName, accessToken, noOfRecords,fromCount,SearchParam);
                if(!responseString.equalsIgnoreCase('Error') )
                {
                    count = getRecordCound(responseString);
                    ArmisDevices = ParseResponse(responseString);
                    AllArmisDevices.addAll(ArmisDevices);
                }
                else
                    return null;
            }
        }

        return AllArmisDevices;
    }

    private static String callAPI(String ArmisDomainName, String accessToken, Integer noOfRecords,Integer fromCount, String SearchParameter ){
        //Now get the Medical Devices 
       // String URL = ArmisDomainName +'/api/v1/devices/?search=category:"Medical%20Therapeutic","Medical%20Diagnostic","Medical%20Support"&length='+noOfRecords+'&from='+fromCount;
        String URL = ArmisDomainName +'/api/v1/devices/?search='+SearchParameter+'&length='+noOfRecords+'&from='+fromCount;
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', accessToken);
        request.setHeader('Accept', 'application/json');
        request.setMethod('GET');
        request.setEndpoint(URL);
        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200 )
            return response.getBody();
        else
            return 'Error';
    }



    private static String GetAccessToken(String URL){
        HttpRequest request = new HttpRequest();
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setMethod('POST');
        request.setEndpoint(URL);
        Http http = new Http();
        HttpResponse response = http.send(request);
        Map<String, Object> topLevel = (Map<String, Object>)System.JSON.deserializeUntyped(response.getBody());
        Object values = (Object)topLevel.get('data');
        String JSONString = JSON.serialize(values);
        Map<String, Object> secLevel = (Map<String, Object>)System.JSON.deserializeUntyped(JSONString);
        string token = (string)secLevel.get('access_token');
        return token;
    }

    private static List<ArmisMedicalDevice> ParseResponse(String responseString){
        Map<String, Object> topLevel = (Map<String, Object>)System.JSON.deserializeUntyped(responseString);
        Object values = (Object)topLevel.get('data');
        String JSONString = JSON.serialize(values);
        Map<String, Object> secLevel = (Map<String, Object>)System.JSON.deserializeUntyped(JSONString);
        List<Object> secValues = (List<Object>)secLevel.get('data');
        String DataString = JSON.serialize(secValues);
        List<ArmisMedicalDevice> deserializedChannel = (List<ArmisMedicalDevice>)System.JSON.deserialize(DataString, List<ArmisMedicalDevice>.class);
        return deserializedChannel;        
    }

    private Static Integer getRecordCound(String responseString){
        Map<String, Object> topLevel = (Map<String, Object>)System.JSON.deserializeUntyped(responseString);
        Object values = (Object)topLevel.get('data');
        String JSONString = JSON.serialize(values);
        Map<String, Object> secLevel = (Map<String, Object>)System.JSON.deserializeUntyped(JSONString);
        Integer countValue = (Integer)secLevel.get('count');
        return countValue;
    }
}