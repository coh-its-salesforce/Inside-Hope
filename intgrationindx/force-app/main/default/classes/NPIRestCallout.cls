@RestResource(urlMapping='/NPIMgmt/*')
global class NPIRestCallout{
    
    @httpPost
    global static String doPostMethod(){
        
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
       // System.debug(requestString);
        COH_parseInsuranceData.deserializeData(requestString);
        return 'Success';
    }
    
    
}