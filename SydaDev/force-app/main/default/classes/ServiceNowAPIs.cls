/*
Author : CloudAction
Date : March 2020
Description : Apex Class to call ServiceNow web APIS to fetch devices data from ServiceNow CMDB.
*/
public with sharing class ServiceNowAPIs {
    public ServiceNowAPIs() {}
    public List<ServiceNowComputerSystem> callServiceNowComputerAPI(String NamedCredential, String URL, Integer fromCount){      
        List<ServiceNowComputerSystem> SNDevices = new List<ServiceNowComputerSystem>();
        String responseString  =  callAPI( NamedCredential, URL, fromCount);
        if(!responseString.equalsIgnoreCase('Error') )
        {
            System.debug(responseString);
            ServiceNowComputerData SNCompData = ParseComputerResponse(responseString);
            Integer count = getComputerRecordCound(SNCompData.result);
            Integer noOfRecords = getComputerTotalRecordCound(SNCompData.result);
            SNDevices = getComputerData(SNCompData.result);
 
        }
        return SNDevices;
    }

    public List<ServiceNowSoftware> callServiceNowSoftwareAPI(String NamedCredential, String URL, Integer fromCount){      
        List<ServiceNowSoftware> SNDevices = new List<ServiceNowSoftware>();
        String responseString  =  callAPI( NamedCredential, URL, fromCount);
        if(!responseString.equalsIgnoreCase('Error') )
        {
            System.debug(responseString);
            ServiceNowSoftwareData SNSoftData = ParseSoftwareResponse(responseString);
            Integer count = getSoftwareRecordCound(SNSoftData.result);
            Integer noOfRecords = getSoftwareTotalRecordCound(SNSoftData.result);
            SNDevices = getSoftwareData(SNSoftData.result);
 
        }
        return SNDevices;
    }

    private String callAPI(String NamedCredential, String InputURL, Integer fromCount){
        //Now get the Service Now Devices         
        String URL = 'callout:'+NamedCredential+'/'+InputURL+'/'+fromCount;
        System.debug('URL -' +URL);
        HttpRequest request = new HttpRequest();
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

    private ServiceNowComputerData ParseComputerResponse(String responseString){
        ServiceNowComputerData allCompData = (ServiceNowComputerData) System.JSON.deserialize(responseString, ServiceNowComputerData.class);
        return allCompData;        
    }

    private ServiceNowSoftwareData ParseSoftwareResponse(String responseString){
        ServiceNowSoftwareData allSoftData = (ServiceNowSoftwareData) System.JSON.deserialize(responseString, ServiceNowSoftwareData.class);
        return allSoftData;        
    }

    private Integer getComputerRecordCound(ServiceNowAPIComputerResult allCompData){
        Integer count = Integer.valueof(allCompData.Count.Trim() == '' ? '0' : allCompData.Count);
        return count;
    }

    private Integer getSoftwareRecordCound(ServiceNowAPISoftwareResult allSoftData){
        Integer count = Integer.valueof(allSoftData.Count.Trim() == '' ? '0' : allSoftData.Count);
        return count;
    }
    private Integer getComputerTotalRecordCound(ServiceNowAPIComputerResult allCompData){
        Integer count = Integer.valueof(allCompData.Total.Trim() == '' ? '0' : allCompData.Total);
        return count;
    }

    private Integer getSoftwareTotalRecordCound(ServiceNowAPISoftwareResult allSoftData){
        Integer count = Integer.valueof(allSoftData.Total.Trim() == '' ? '0' : allSoftData.Total);
        return count;
    }
    private List<ServiceNowComputerSystem> getComputerData(ServiceNowAPIComputerResult allCompData){
        return (List<ServiceNowComputerSystem>)allCompData.Data;
    }
    private List<ServiceNowSoftware> getSoftwareData(ServiceNowAPISoftwareResult allSoftData){
        return (List<ServiceNowSoftware>)allSoftData.Data;
    }
}