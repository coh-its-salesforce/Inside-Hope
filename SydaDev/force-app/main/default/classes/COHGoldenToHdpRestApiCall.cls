/*
* This class contains Integration between sanboxes.
* 
* Balaji Rao
* City of Hope
* Copyright (c) 2019
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*
************Related to HDP Target org *************
private final String clientId = '3MVG9pHRjzOBdkd.Q8MJIQySikllwzUFkG_svN1SPufNrXcgtlZo35ek8BEqQYz_SbQ42QLMF12BrqpgkYYOg';
private final String clientSecret = '7115148004681473242';
private final String username = 'cityofhope@hdplus.com.test';
private final String password = 'deus5u3ydxa8j7qy';
string endPoint ='https://hdplus--test.cs3.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/';
*/


public class COHGoldenToHdpRestApiCall {

     //using Custom Metadata Type for the values of clientID,ClientSecret,Username,Password and endpoint.
    GoldenToHDPvalues__mdt gtohObj=[select clientId__c,clientSecret__c,password__c,username__c,endPoint__c,AccessTokenEndPoint__c from GoldenToHDPvalues__mdt];
    
    private final String clientId=gtohObj.clientId__c;
    private final string clientSecret=gtohObj.clientSecret__c;
    private final string username=gtohObj.username__c;
    private final string password=gtohObj.password__c;
	public string endPoint1 = gtohObj.endPoint__c;
    public string AccessTokenEndPoint1 = gtohObj.AccessTokenEndPoint__c;
    
    private final string chatterObjId;
    //This method is used for storing responce from target 
    public class deserializeResponse        
    {
        
        public String id;
        public String access_token;
        public boolean success;
    }
    
    //this class is used to declaire a variable to use in chatter feed method.
    public class WrapperCls
    {
        @auraEnabled
        public string Chatterid{set;get;}
        
    }
    /*
* this method related to access token
* @param is object of the COHGoldenToHdpRestApiCall 
* 
* @return  accessToken
* 
*/
    public String ReturnAccessToken(COHGoldenToHdpRestApiCall  obj)
    {
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
		String accessToken;
        
        Http httpobj = new Http();        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(AccessTokenEndPoint1); 
        req.setBody(reqbody);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setmethod('POST');
        
        HttpResponse res = httpobj.send(req);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        accessToken = string.valueof(m.get('access_token'));
        // deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        
        return accessToken;
    }
   @auraEnabled
    public static void creatProgramDeterminitionSection(String pdrecordId)
    {	
        WrapperCls awobj =new WrapperCls();
        awobj.Chatterid=pdrecordId;
        
        //these are the variables to store the data,which we fetched from soql quiery and used in JSON string to map with target org fields 
        // using to map with patient info of account object
        string accountid;
        String TargetHdpParentId;
        string TargetHdpRecordId;
        string PatientFirstName;
        string PatientFirstNamestr;
        string PatientLastName;
        string PatientLastNamestr;
        String myDate3;
        string PatDOB;
        string PatDOBstr;
        Date PatientDOB;
        string PatientState;
        string PatientStatestr;
        string PatientInsuranceId;
        string PatientInsuranceIdstr;
        //these variables used to map with local physician section of account object
        string name;
        string namestr;
        string street;
        string streetstr;
        string city;
        string citystr;
        string state; 
        string statestr;
        string country;
        string countrystr;
        string postalcode;
        string postalcodestr;
        Decimal postalcode1;
        String fax;
        string faxstr;
        Decimal fax1;
        string Treatment;
        string Treatmentstr;
        string Credentials;
        string Credentialsstr;
        string Mailingaddress;
        string Mailingaddressstr;
        string PhysicianPhone; 
        string PhysicianPhonestr;
        string AssoFacilitate;
        string AssoFacilitatestr;
        string physpeaciality;
        string physpeacialitystr;
        string ExternalRefer;
        string myDate1;
        string myDate2;
        if(pdrecordId != null) {
            //Referred_to_Physician_Zip__c, Referred_to_Physician_Fax_Number__c,//
            
            AM_Program_Determination__c pdo =[select Date_of_Diagnosis_Patient_Reported_COH__c , Determination_Date__c ,
                                           Determination_Outcome__c , Determination_Outcome_Reason__c ,
                                           Primary_Diagnosis_Patient_Reported__c,Clinical_Screening_Summary__c,AM_Evaluation_Request_Name__c,
                                           Sent_to_HDP_ID__c,Referral_to_Physician_First_Last_Name__c, Referral_to_Physician_Credential__c, 
                                           Referral_to_Physician_Specialty__c, Referral_to_Physician_Street_Address__c,
                                           Referral_to_Physician_City__c, Referral_to_Physician_State__c,
                                           Referral_to_Physician_Country__c,Referral_to_Physician_Zip__c, Referral_to_Physician_Fax_Number__c,
                                           Referral_to_Physician_Phone_Number__c,
                                           Referral_to_Associated_Facilities__c
                                           from AM_Program_Determination__c  where id=:pdrecordId];
            
            //here we are declairing the variables and used to store program determination object data
            TargetHdpRecordId = pdo.Sent_to_HDP_ID__c;
            
            date DeterminationDate = pdo.Determination_Date__c;
            Datetime dt1 = datetime.newInstance(DeterminationDate.year(), DeterminationDate.month(),DeterminationDate.day());
            String determDate = dt1.format('yyyy-MM-dd');
            myDate1 = (String.isBlank(determDate)? '' : determDate);
            date DateofDiagnosis   = pdo.Date_of_Diagnosis_Patient_Reported_COH__c;
            Datetime dt2 = datetime.newInstance(DateofDiagnosis.year(), DateofDiagnosis.month(),DateofDiagnosis.day());
            String DiagnosisDate = dt2.format('yyyy-MM-dd');
            myDate2 = (String.isBlank(DiagnosisDate)? '' : DiagnosisDate);
            string DeterminationOutcomestr =pdo.Determination_Outcome__c;
            string DeterminationOutcome = (String.isBlank(DeterminationOutcomestr)? '' : DeterminationOutcomestr);
            string DeterminationOutcomeReasonstr =pdo.Determination_Outcome_Reason__c;
            string DeterminationOutcomeReason = (String.isBlank(DeterminationOutcomeReasonstr)? '' : DeterminationOutcomeReasonstr);
            string PrimaryDiagnosisstr = pdo.Primary_Diagnosis_Patient_Reported__c;
            string PrimaryDiagnosis = (String.isBlank(PrimaryDiagnosisstr)? '' : PrimaryDiagnosisstr);
            string clinicalnotesstr = pdo.Clinical_Screening_Summary__c;
            string clinicalnotes1 = (String.isBlank(clinicalnotesstr)? '' : clinicalnotesstr);
            string clinicalnotes = clinicalnotes1.replaceAll( '\\s+', '');  
            
             /*if external id of target org is null or empty --insert a record
send_to_HDP_ID__c field is holding the id of target org record  */
            
            if(string.isEmpty(TargetHdpRecordId))
            {
                
                //if(pdo.Patient_Account__c !=null)
                  if(pdo.AM_Evaluation_Request_Name__c !=null)  
                {//Local_Physician_Zip__c,Local_Physician_Fax_Number__c,//
                    
                    AM_Evaluation_Request__c ac = [select id,AM_Account__c,First_Name__c,LastName__c,Mailing_State_Province__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                                      Patient_COE_Benefit_IdentificationNumber__c,Name,
                                                      Treatment_Patient_Reported_to_HDP__c from AM_Evaluation_Request__c where id =:pdo.AM_Evaluation_Request_Name__c AND AM_Account__c!=null];
                                        
                    TargetHdpParentId = ac.HDP_Parent_ID__c;
                    ExternalRefer = ac.Name;
                    PatientFirstNamestr= ac.First_Name__c;
                    PatientFirstName = (String.isBlank(PatientFirstNamestr)? '' : PatientFirstNamestr);
                    PatientLastNamestr = ac.LastName__c;
                    PatientLastName = (String.isBlank(PatientLastNamestr)? '' : PatientLastNamestr);
                    
                    PatientDOB = ac.Birthdate__c;
                    Datetime dt3 = datetime.newInstance(PatientDOB.year(), PatientDOB.month(),PatientDOB.day());
                    PatDOB = dt3.format('yyyy-MM-dd');
                    myDate3 = (String.isBlank(PatDOB)? '' : PatDOB);
                    PatientStatestr = ac.Mailing_State_Province__c;
                    PatientState = (String.isBlank(PatientStatestr)? '' : PatientStatestr);
                    
                    PatientInsuranceIdstr = ac.Patient_COE_Benefit_IdentificationNumber__c;  
                    PatientInsuranceId = (String.isBlank(PatientInsuranceIdstr)? '' : PatientInsuranceIdstr);
                    
                    Treatmentstr = ac.Treatment_Patient_Reported_to_HDP__c;
                    Treatment = (String.isBlank(Treatmentstr)? '' : Treatmentstr);
                    //pd
                    namestr = pdo.Referral_to_Physician_First_Last_Name__c;
                    name = (String.isBlank(namestr)? '' : namestr);
                    Credentialsstr = pdo.Referral_to_Physician_Credential__c;
                    Credentials = (String.isBlank(Credentialsstr)? '' : Credentialsstr);
                    physpeacialitystr = pdo.Referral_to_Physician_Specialty__c;
                    physpeaciality = (String.isBlank(physpeacialitystr)? '' : physpeacialitystr); 
                    streetstr = pdo.Referral_to_Physician_Street_Address__c;
                    street = (String.isBlank(streetstr)? '' : streetstr);
                    citystr = pdo.Referral_to_Physician_City__c;
                    city = (String.isBlank(citystr)? '' : citystr);
                    statestr =pdo.Referral_to_Physician_State__c;
                    state = (String.isBlank(statestr)? '' : statestr);
                   
                    postalcodestr = pdo.Referral_to_Physician_Zip__c;
                    postalcode = (string.isBlank(postalcodestr)? '' : postalcodestr);
                    
                    countrystr = pdo.Referral_to_Physician_Country__c;
                    country = (String.isBlank(countrystr)? '' : countrystr);
                    PhysicianPhonestr = pdo.Referral_to_Physician_Phone_Number__c;
                    PhysicianPhone = (String.isBlank(PhysicianPhonestr)? '' : PhysicianPhonestr);
                    
                    faxstr =pdo.Referral_to_Physician_Fax_Number__c;
                    fax = (String.isBlank(faxstr)? '' : faxstr);
                    
                    AssoFacilitatestr = pdo.Referral_to_Associated_Facilities__c;
                    AssoFacilitate =(String.isBlank(AssoFacilitatestr)? '' : AssoFacilitatestr); 
                    
                }
                
                String accessToken;
                COHGoldenToHdpRestApiCall  obj=new COHGoldenToHdpRestApiCall ();
                accessToken = obj.ReturnAccessToken(obj);
                system.debug('accessToken:'+accessToken);
                
                if(accessToken != null)
                {
                    
                   //Target org End point
                    //String endPoint ='https://cityofhope--EpicInteg.cs26.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/';//post 
                    //String endPoint = 'https://hdplus--test.cs3.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/';
                    string endPoint = obj.endPoint1 +'services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/';
                  
                    //Declairing JSON string
                    //String jsonstr ='{"Facility_Record_ID__c":"'+accountid+'","Determination_Date__c" : "' + myDate1 + '","Date_of_Diagnosis__c" : "' + myDate2 + '","Determination_Outcome__c":"'+DeterminationOutcome+'","Determination_Outcome_Reason__c":"'+DeterminationOutcomeReason+'","Primary_Diagnosis__c":"'+PrimaryDiagnosis+'","Clinical_Notes__c":"'+clinicalnotes+'","Treatment__c":"'+Treatment+'","Physician_First_Name_Last_Name__c":"'+name+'","Physician_Credentials__c":"'+Credentials+'","Physician_Street_Address__c":"'+street+'","Physician_City__c":"'+city+'","Physician_State__c":"'+state+'","Physician_Zip_Code__c":"'+postalcode+'","Physician_Country__c":"'+country+'","Physician_Phone_Number__c":"'+PhysicianPhone+'","Physician_Fax_Number__c":"'+fax+'","Associated_Facilities__c":"'+AssoFacilitate+'","Physician_Specialty__c":"'+physpeaciality+'","Patient_First_Name__c":"'+PatientFirstName+'","Patient_Last_Name__c":"'+PatientLastName+'","Patient_DOB__c" :"' + myDate3 + '","Patient_State__c":"'+PatientState+'","Patient_Insurance_Id__c":"'+PatientInsuranceId+'"}';            
                    String jsonstrHDP ='{"ParentId__c":"'+TargetHdpParentId+'","External_Reference_ID__c":"'+ExternalRefer+'","Determination_Date__c" : "' + myDate1 + '","Date_of_Diagnosis__c" : "' + myDate2 + '","Determination_Outcome__c":"'+DeterminationOutcome+'","Determination_Outcome_Reason__c":"'+DeterminationOutcomeReason+'","Primary_Diagnosis__c":"'+PrimaryDiagnosis+'","Clinical_Notes__c":"'+clinicalnotes+'","Treatment__c":"'+Treatment+'","Physician_First_Name_Last_Name__c":"'+name+'","Physician_Credentials__c":"'+Credentials+'","Physician_Street_Address__c":"'+street+'","Physician_City__c":"'+city+'","Physician_State__c":"'+state+'","Physician_Zip_Code__c":"'+postalcode+'","Physician_Country__c":"'+country+'","Physician_Phone_Number__c":"'+PhysicianPhone+'","Physician_Fax_Number__c":"'+fax+'","Associated_Facilities__c":"'+AssoFacilitate+'","Physician_Specialty__c":"'+physpeaciality+'","Patient_First_Name__c":"'+PatientFirstName+'","Patient_Last_Name__c":"'+PatientLastName+'","Patient_DOB__c" :"' + myDate3 + '","Patient_State__c":"'+PatientState+'","Patient_Insurance_Id__c":"'+PatientInsuranceId+'"}';            
                    system.Debug('PD Insert:'+jsonstrHDP);
                    Http httpobj2 = new Http();                    
                    HttpRequest req1 = new HttpRequest();
                    req1.setHeader('Authorization','Bearer ' + accessToken);
                    req1.setHeader('Content-Type','application/json');
                    req1.setHeader('accept','application/json');
                    req1.setHeader('charset', 'utf-8');
                    req1.setBody(jsonstrHDP);
                    req1.setMethod('POST');
                    req1.setEndpoint(endPoint);
                    System.debug(endPoint);
                    HttpResponse res1 = httpobj2.send(req1);
                    string strResponse=res1.getBody();
                    system.Debug('result is:'+strResponse);  
                    system.Debug('getStatusCode is:'+res1.getStatusCode());  
                    if (res1.getStatusCode() == 201)
                    {   //Here we are using Try-Catch, Try block for Deserialise and Cacth block for log Errors.               
                        try
                        {
                            deserializeResponse resp2 = (deserializeResponse)JSON.deserialize(res1.getbody(),deserializeResponse.class); 
                            if(resp2.success)
                            {
                                string ResponseId=resp2.id;
                                system.debug('External Record Id is:'+ResponseId);                         
                                COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'Program Determination successfully created in the customer environment');
                                
                                //here we are updating the time stamp field of program detemination object
                                AM_Program_Determination__c pdc1 = [select Sent_to_HDP_ID__c,Successfully_Sent_to_HDP__c,Successfully_Sent_to_HDP_Date_Time__c from AM_Program_Determination__c where id=:pdrecordId ];
                                pdc1.Successfully_Sent_to_HDP__c=true;
                                pdc1.Successfully_Sent_to_HDP_Date_Time__c=system.now();
                                pdc1.Sent_to_HDP_ID__c = ResponseId;
                                update pdc1; 
                                
                                //here we are updating the HDP Record Id field of RW_Evaluation_Request__c object
                                AM_Evaluation_Request__c obj1 = [select HDP_Record_ID__c from AM_Evaluation_Request__c where id =:pdo.AM_Evaluation_Request_Name__c AND AM_Account__c!=null];
                                obj1.HDP_Record_ID__c = ResponseId;
                                update obj1;									
                            }
                        }
                        catch(Exception e)
                        {
                            if(e.getMessage()!=null)
                            {
                                
                                COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred: ' + e.getMessage());
                            }
                        }   
                    }                    
                    else
                    {
                        if(string.isNotBlank(strResponse))
                        {
                            COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred: ' + strResponse);
                        }
                    }
                }
                
            }
            	//if external id of target org is not null --then update
            else{
                
                if(pdo.AM_Evaluation_Request_Name__c !=null)  
                {//Local_Physician_Zip__c,Local_Physician_Fax_Number__c,//
                     AM_Evaluation_Request__c ac = [select id,AM_Account__c,First_Name__c,LastName__c,Mailing_State_Province__c,HDP_Record_ID__c,HDP_Parent_ID__c,Birthdate__c,
                                                      Patient_COE_Benefit_IdentificationNumber__c,Name,
                                                      Treatment_Patient_Reported_to_HDP__c from AM_Evaluation_Request__c where id =:pdo.AM_Evaluation_Request_Name__c AND AM_Account__c!=null];
                                        
                    TargetHdpParentId = ac.HDP_Parent_ID__c;
                    ExternalRefer =ac.Name;
                    PatientFirstNamestr= ac.First_Name__c;
                    PatientFirstName = (String.isBlank(PatientFirstNamestr)? '' : PatientFirstNamestr);
                    PatientLastNamestr = ac.LastName__c;
                    PatientLastName = (String.isBlank(PatientLastNamestr)? '' : PatientLastNamestr);
                    
                    PatientDOB = ac.Birthdate__c;
                    Datetime dt3 = datetime.newInstance(PatientDOB.year(), PatientDOB.month(),PatientDOB.day());
                    PatDOB = dt3.format('yyyy-MM-dd');
                    myDate3 = (String.isBlank(PatDOB)? '' : PatDOB);
                    PatientStatestr = ac.Mailing_State_Province__c;
                    PatientState = (String.isBlank(PatientStatestr)? '' : PatientStatestr);
                    
                    PatientInsuranceIdstr = ac.Patient_COE_Benefit_IdentificationNumber__c;  
                    PatientInsuranceId = (String.isBlank(PatientInsuranceIdstr)? '' : PatientInsuranceIdstr);
                    
                    Treatmentstr = ac.Treatment_Patient_Reported_to_HDP__c;
                    Treatment = (String.isBlank(Treatmentstr)? '' : Treatmentstr);
                    //pd
                    namestr = pdo.Referral_to_Physician_First_Last_Name__c;
                    name = (String.isBlank(namestr)? '' : namestr);
                    Credentialsstr = pdo.Referral_to_Physician_Credential__c;
                    Credentials = (String.isBlank(Credentialsstr)? '' : Credentialsstr);
                    physpeacialitystr = pdo.Referral_to_Physician_Specialty__c;
                    physpeaciality = (String.isBlank(physpeacialitystr)? '' : physpeacialitystr); 
                    streetstr = pdo.Referral_to_Physician_Street_Address__c;
                    street = (String.isBlank(streetstr)? '' : streetstr);
                    citystr = pdo.Referral_to_Physician_City__c;
                    city = (String.isBlank(citystr)? '' : citystr);
                    statestr =pdo.Referral_to_Physician_State__c;
                    state = (String.isBlank(statestr)? '' : statestr);
                   
                    postalcodestr = pdo.Referral_to_Physician_Zip__c;
                    postalcode = (string.isBlank(postalcodestr)? '' : postalcodestr);
                    
                    countrystr = pdo.Referral_to_Physician_Country__c;
                    country = (String.isBlank(countrystr)? '' : countrystr);
                    PhysicianPhonestr = pdo.Referral_to_Physician_Phone_Number__c;
                    PhysicianPhone = (String.isBlank(PhysicianPhonestr)? '' : PhysicianPhonestr);
                    
                    faxstr =pdo.Referral_to_Physician_Fax_Number__c;
                    fax = (String.isBlank(faxstr)? '' : faxstr);
                    
                    AssoFacilitatestr = pdo.Referral_to_Associated_Facilities__c;
                    AssoFacilitate =(String.isBlank(AssoFacilitatestr)? '' : AssoFacilitatestr); 
                    
                }
                
                 String accessToken;
                COHGoldenToHdpRestApiCall  obj=new COHGoldenToHdpRestApiCall ();
                accessToken = obj.ReturnAccessToken(obj);
                system.debug('accessToken:'+accessToken);
                
                if(accessToken != null)
                {
                     //String endPoint ='https://cityofhope--EpicInteg.cs26.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/'+ hdpid +'?_HttpMethod=PATCH';// patch
                   // String endPoint ='https://hdplus--test.cs3.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/'+ TargetHdpRecordId +'?_HttpMethod=PATCH';// patch
                    string endPoint = obj.endPoint1+'services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/'+ TargetHdpRecordId +'?_HttpMethod=PATCH';
                    
                    //String jsonstr ='{"Oncology_Clinical_Facility_ID__c":"'+hdpid+'","Facility_Record_ID__c":"'+accountid+'","Date_of_Diagnosis__c" : "' + myDate2 + '","Determination_Date__c" : "' + myDate1 + '","Patient_DOB__c" :"' + myDate3 + '","Determination_Outcome__c":"'+DeterminationOutcome+'","Determination_Outcome_Reason__c":"'+DeterminationOutcomeReason+'","Primary_Diagnosis__c":"'+PrimaryDiagnosis+'","Clinical_Notes__c":"'+clinicalnotes+'","Treatment__c":"'+Treatment+'","Physician_First_Name_Last_Name__c":"'+name+'","Physician_Credentials__c":"'+Credentials+'","Physician_Street_Address__c":"'+street+'","Physician_City__c":"'+city+'","Physician_State__c":"'+state+'","Physician_Zip_Code__c":"'+postalcode+'","Physician_Country__c":"'+country+'","Physician_Phone_Number__c":"'+PhysicianPhone+'","Physician_Fax_Number__c":"'+fax+'","Associated_Facilities__c":"'+AssoFacilitate+'","Physician_Specialty__c":"'+physpeaciality+'","Patient_First_Name__c":"'+PatientFirstName+'","Patient_Last_Name__c":"'+PatientLastName+'","Patient_State__c":"'+PatientState+'","Patient_Insurance_Id__c":"'+PatientInsuranceId+'"}';            
                    //String jsonstr ='{"ParentId__c":"'+TargetHdpId+'","Facility_Record_ID__c":"'+accountid+'","Determination_Date__c" : "' + myDate1 + '","Date_of_Diagnosis__c" : "' + myDate2 + '","Determination_Outcome__c":"'+DeterminationOutcome+'","Determination_Outcome_Reason__c":"'+DeterminationOutcomeReason+'","Primary_Diagnosis__c":"'+PrimaryDiagnosis+'","Clinical_Notes__c":"'+clinicalnotes+'","Treatment__c":"'+Treatment+'","Physician_First_Name_Last_Name__c":"'+name+'","Physician_Credentials__c":"'+Credentials+'","Physician_Street_Address__c":"'+street+'","Physician_City__c":"'+city+'","Physician_State__c":"'+state+'","Physician_Zip_Code__c":"'+postalcode+'","Physician_Country__c":"'+country+'","Physician_Phone_Number__c":"'+PhysicianPhone+'","Physician_Fax_Number__c":"'+fax+'","Associated_Facilities__c":"'+AssoFacilitate+'","Physician_Specialty__c":"'+physpeaciality+'","Patient_First_Name__c":"'+PatientFirstName+'","Patient_Last_Name__c":"'+PatientLastName+'","Patient_DOB__c" :"' + myDate3 + '","Patient_State__c":"'+PatientState+'","Patient_Insurance_Id__c":"'+PatientInsuranceId+'"}';            
                    String jsonstrHDP ='{"Facility_Record_ID__c":"'+TargetHdpRecordId+'","External_Reference_ID__c":"'+ExternalRefer+'","Determination_Date__c" : "' + myDate1 + '","Date_of_Diagnosis__c" : "' + myDate2 + '","Determination_Outcome__c":"'+DeterminationOutcome+'","Determination_Outcome_Reason__c":"'+DeterminationOutcomeReason+'","Primary_Diagnosis__c":"'+PrimaryDiagnosis+'","Clinical_Notes__c":"'+clinicalnotes+'","Treatment__c":"'+Treatment+'","Physician_First_Name_Last_Name__c":"'+name+'","Physician_Credentials__c":"'+Credentials+'","Physician_Street_Address__c":"'+street+'","Physician_City__c":"'+city+'","Physician_State__c":"'+state+'","Physician_Zip_Code__c":"'+postalcode+'","Physician_Country__c":"'+country+'","Physician_Phone_Number__c":"'+PhysicianPhone+'","Physician_Fax_Number__c":"'+fax+'","Associated_Facilities__c":"'+AssoFacilitate+'","Physician_Specialty__c":"'+physpeaciality+'","Patient_First_Name__c":"'+PatientFirstName+'","Patient_Last_Name__c":"'+PatientLastName+'","Patient_DOB__c" :"' + myDate3 + '","Patient_State__c":"'+PatientState+'","Patient_Insurance_Id__c":"'+PatientInsuranceId+'"}';            
                    system.debug('PD Update:'+jsonstrHDP);
                    Http httpobj3 = new Http();
                    HttpRequest req1 = new HttpRequest();
                    req1.setHeader('Authorization','Bearer ' + accessToken);
                    req1.setHeader('Content-Type','application/json');
                    req1.setHeader('accept','application/json');
                    req1.setHeader('charset', 'utf-8');
                    req1.setBody(jsonstrHDP);
                    req1.setMethod('POST');
                    req1.setEndpoint(endPoint);
                    HttpResponse res1 = httpobj3.send(req1);
                    string strResponse=res1.getBody();
                    system.Debug('result is:'+strResponse);
                    system.Debug('getStatusCode is:'+res1.getStatusCode());  
                    if (res1.getStatusCode() == 204)
                    {                    
                        try
                        {
                            //deserializeResponse resp2 = (deserializeResponse)JSON.deserialize(res1.getbody(),deserializeResponse.class); 
                            //if(resp2.success){
                            COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'Program Determination successfully updated in the customer environment');
                            AM_Program_Determination__c pdc1 = [select Sent_to_HDP_ID__c,Successfully_Sent_to_HDP__c,Successfully_Sent_to_HDP_Date_Time__c from AM_Program_Determination__c where id=:pdrecordId ];
                            pdc1.Successfully_Sent_to_HDP__c=true;
                            pdc1.Successfully_Sent_to_HDP_Date_Time__c=system.now();
                            update pdc1;    
                            //}
                        }
                        catch(Exception e)
                        {
                            if(e.getMessage()!=null)
                            {
                                COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred:' + e.getMessage());
                            }                            
                        }   
                    }
                    else
                    {
                        if(string.isNotBlank(strResponse))
                        {
                            COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred: ' + strResponse);
                        }
                    }
                }
            }		

        }
    }
     /*
* This method is used to creating the PlanOfCare Section on target org
* 
* @param   planID -- id of the PlanOfCare object
* 
*/
    @auraEnabled
    public static void creatPlaneOfCareSection(String planID)
        
    {	
        WrapperCls awobj=new WrapperCls();
        awobj.Chatterid=planID;
        
        string TargetHdpRecordId;
        //These are the variables used to store the data of plan of care object which we fetched form soql query and used in JSON string
        string	planofcarehdpid;        
        Date SubmissionDate;
        string ProposedServiceType;
        string ProposedServiceTypestr;
        string ConsultationTypes;
        string ConsultationTypesstr;
        String AdditionalDiagnostics;
        String AdditionalDiagnosticsstr;
        
        //Newly added fields -08-08-2019
        String CohPrimaryname;
        string ExternalRefer;
        Date EvaluationDate1;
        Date EvaluationDate2;
        Date EstimatedArrivalDate;
        Date EstimatedDepartureDate;
        String RecommendedModeofTransportation;
        String RecommendedModeofTransportationstr;
        String MedicallyAllowableModeofTransport;
        String MedicallyAllowableModeofTransportstr;
        DateTime FirstAppEvadt;
        string myDate;
        string EvDate1;
        String EvalDate6;
        string LastappDate9;
        string Esadate3;
        String Esadate4;
        String EvDate2;
        String Evaldate8;
        String Esdate4;
      	DateTime EvaluationDt;
        DateTime LastAppointmentDt;
        string evdate02 = null;
        date dtobj = null;
        //string accountRecordid;
        
        if(planID != null) {
            
            AM_Plan_Of_Care__c plan =[select Facility_Plan_of_Care_Submission_Date__c,CoH_Primary__c,Proposed_Service_Type__c,Consultation_Type__c,AM_Evaluation_Request_Name__c,
                                   Additional_Diagnostic_EvaluationServices__c,Evaluation_Date_1__c,Evaluation_Date_2__c,
                                   First_AppointmentTimeOn_First_Evaluation__c,Evaluation_Date_Time__c,
                                   Last_Appointment_Date_Time__c,Estimated_Arrival_Date__c,Estimated_Departure_Date__c,
                                   Recommended_Mode_of_Transportation__c,Medically_Allowable_Mode_of_Transport__c from AM_Plan_Of_Care__c where id=:planID];
                        
            //planofcarehdpid =plan.PlaneOFCare_Send_to_HDP_ID__c;
            SubmissionDate = plan.Facility_Plan_of_Care_Submission_Date__c;
           if(SubmissionDate != null){
                Datetime dt = datetime.newInstance(SubmissionDate.year(), SubmissionDate.month(),SubmissionDate.day());
                String myDatestr = (String)dt.format('yyyy-MM-dd');
                       myDate = myDatestr;
                     }    else if(SubmissionDate == null){
                          myDate = null;
                           system.debug('evdate2 is'+myDate);
                    }
            
            ProposedServiceTypestr = plan.Proposed_Service_Type__c;
            ProposedServiceType = (String.isBlank(ProposedServiceTypestr)? '' : ProposedServiceTypestr);
            ConsultationTypesstr = plan.Consultation_Type__c;
            ConsultationTypes = (String.isBlank(ConsultationTypesstr)? '' : ConsultationTypesstr);
            AdditionalDiagnosticsstr = plan.Additional_Diagnostic_EvaluationServices__c;
            AdditionalDiagnostics = (String.isBlank(AdditionalDiagnosticsstr)? '' : AdditionalDiagnosticsstr);
            
            if(plan.AM_Evaluation_Request_Name__c !=null)
            {
                
                AM_Evaluation_Request__c acobj = [select HDP_Record_ID__c,Name from AM_Evaluation_Request__c where id =:plan.AM_Evaluation_Request_Name__c];
                
                Contact conObj= [select id,name from Contact where id=:plan.CoH_Primary__c];
                
                
                TargetHdpRecordId = acobj.HDP_Record_ID__c;
                //Newly added changes 08-08-2019
                ExternalRefer = acobj.name;
                CohPrimaryname =conobj.name;
                EvaluationDate1 = plan.Evaluation_Date_1__c;
                if(EvaluationDate1 != null){
                Datetime dt2 = datetime.newInstance(EvaluationDate1.year(), EvaluationDate1.month(),EvaluationDate1.day());
                String myDatestr1 = (String)dt2.format('yyyy-MM-dd');
                       EvDate1 = myDatestr1;
                     }    else if(EvaluationDate1 == null){
                          EvDate1 = null;
                           system.debug('evdate1 is'+EvDate1);
                    }
                
                EvaluationDate2 = plan.Evaluation_Date_2__c;
                if(EvaluationDate2 != null){
                Datetime dt2 = datetime.newInstance(EvaluationDate2.year(), EvaluationDate2.month(),EvaluationDate2.day());
                String myDatestr2 = (String)dt2.format('yyyy-MM-dd');
                       EvDate2 = myDatestr2;
                     }    else if(EvaluationDate2 == null){
                          EvDate2 = null;
                           system.debug('evdate2 is'+EvDate2);
                    }
                           
                EstimatedArrivalDate =plan.Estimated_Arrival_Date__c;
                if(EstimatedArrivalDate != null){
                Datetime dt3 = datetime.newInstance(EstimatedArrivalDate.year(), EstimatedArrivalDate.month(),EstimatedArrivalDate.day());
                String myDatestr3 = (String)dt3.format('yyyy-MM-dd');
                       EsaDate3 = myDatestr3;
                     }    else if(EstimatedArrivalDate == null){
                          EsaDate3 = null;
                           system.debug('EstimatedArrivalDate is'+EsaDate3);
                    }
                
                EstimatedDepartureDate = plan.Estimated_Departure_Date__c;
                if(EstimatedDepartureDate != null){
                Datetime dt4 = datetime.newInstance(EstimatedDepartureDate.year(), EstimatedDepartureDate.month(),EstimatedDepartureDate.day());
                String myDatestr4 = (String)dt4.format('yyyy-MM-dd');
                       Esdate4 = myDatestr4;
                     }    else if(EstimatedDepartureDate == null){
                          Esdate4 = null;
                           system.debug('EstimatedDepartureDate is'+Esdate4);
                    }
                
                FirstAppEvadt  = plan.First_AppointmentTimeOn_First_Evaluation__c;
               if(FirstAppEvadt != null){
                Datetime dt5 = datetime.newInstance(FirstAppEvadt.year(), FirstAppEvadt.month(),FirstAppEvadt.day());
                String formatted = (String)dt5.format('yyyy-MM-dd');
                       EvalDate6 = formatted;
                     }    else if(FirstAppEvadt == null){
                          EvalDate6 = null;
                           system.debug('FirstAppEvadt is'+EvalDate6);
                    }
                //----------------------------------
                EvaluationDt = plan.Evaluation_Date_Time__c;
                if(EvaluationDt != null){
                Datetime dt6 = datetime.newInstance(EvaluationDt.year(), EvaluationDt.month(),EvaluationDt.day());
                String formatted = (String)dt6.format('yyyy-MM-dd');
                       EvalDate8 = formatted;
                     }    else if(EvaluationDt == null){
                          EvalDate8 = null;
                           system.debug('EvaluationDt is'+EvalDate8);
                    }
                //EvalDate8 = (String.isBlank(formatted2)? null : formatted2);
                
                LastAppointmentDt = plan.Last_Appointment_Date_time__c;
                if(LastAppointmentDt != null){
                Datetime dt7 = datetime.newInstance(LastAppointmentDt.year(), LastAppointmentDt.month(),LastAppointmentDt.day());
                String formatted3 = (String)dt7.format('yyyy-MM-dd');
                       LastappDate9 = formatted3;
                     }    else if(LastAppointmentDt == null){
                          LastappDate9 = null;
                           system.debug('LastAppointmentDt is'+EvalDate8);
                    }
                RecommendedModeofTransportationstr = plan.Recommended_Mode_of_Transportation__c;
                RecommendedModeofTransportation = (String.isBlank(RecommendedModeofTransportationstr)? '' : RecommendedModeofTransportationstr);//
                MedicallyAllowableModeofTransportstr = plan.Medically_Allowable_Mode_of_Transport__c;
                MedicallyAllowableModeofTransport = (String.isBlank(MedicallyAllowableModeofTransportstr)? '' : MedicallyAllowableModeofTransportstr);//
                   
                String accessToken;
                COHGoldenToHdpRestApiCall  obj=new COHGoldenToHdpRestApiCall();
                accessToken = obj.ReturnAccessToken(obj);
                system.debug('accessToken:'+accessToken); 
                
                if(accessToken !=null)
                {
                  //Declairing the target org End Point			
                    //String endPoint = 'https://hdplus--test.cs3.my.salesforce.com/services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/'+TargetHdpRecordId+'?_HttpMethod=PATCH';
                    string endPoint = obj.endPoint1+'services/data/v32.0/sobjects/Oncology_Clinical_Facility__c/'+TargetHdpRecordId+'?_HttpMethod=PATCH';
                    String jsonstrHDP;
                    //String jsonstrHDP = '{"Facility_Record_ID__c":"'+TargetHdpRecordId+'","External_Reference_ID__c":"'+ExternalRefer+'","Plan_of_Care_Submission_Date__c":"' + myDate + '","Proposed_Service_Type__c" : "'+ ProposedServiceType +'","Consultation_Types__c" : "' + ConsultationTypes + '","Additional_diagnostics_outside_bundle__c" : "' + AdditionalDiagnostics + '"}';
                    
                    if(plan.Evaluation_Date_2__c != null){
                            jsonstrHDP ='{"Facility_Record_ID__c":"'+TargetHdpRecordId+'","External_Reference_ID__c":"'+ExternalRefer+'","Plan_of_Care_Submission_Date__c":"' + myDate + '","Proposed_Service_Type__c" : "'+ ProposedServiceType +'","Consultation_Types__c" : "' + ConsultationTypes + '","Additional_diagnostics_outside_bundle__c" : "' + AdditionalDiagnostics + '","CoH_Primary__c":"'+CohPrimaryname+'","Evaluation_Date_1__c":"'+EvDate1+'","First_AppointmentTimeOn_First_Evaluation__c":"'+EvalDate6+'","Last_Appointment_Date_and_time__c":"'+LastappDate9+'","Estimated_Arrival_Date__c":"'+EsaDate3+'","Estimated_Departure_Date__c":"'+Esdate4+'","Medically_Allowable_Mode_of_Transport__c":"'+MedicallyAllowableModeofTransport+'","Recommended_Mode_of_Transportation__c":"'+RecommendedModeofTransportation+'","Evaluation_Date_2__c":"'+EvDate2+'","Evaluation_Date_and_Time__c":"'+EvalDate8+'"}';
                            System.debug('POC Insert:'+jsonstrHDP);
                    }
                    Else{
                         	jsonstrHDP ='{"Facility_Record_ID__c":"'+TargetHdpRecordId+'","External_Reference_ID__c":"'+ExternalRefer+'","Plan_of_Care_Submission_Date__c":"' + myDate + '","Proposed_Service_Type__c" : "'+ ProposedServiceType +'","Consultation_Types__c" : "' + ConsultationTypes + '","Additional_diagnostics_outside_bundle__c" : "' + AdditionalDiagnostics + '","CoH_Primary__c":"'+CohPrimaryname+'","Evaluation_Date_1__c":"'+EvDate1+'","First_AppointmentTimeOn_First_Evaluation__c":"'+EvalDate6+'","Last_Appointment_Date_and_time__c":"'+LastappDate9+'","Estimated_Arrival_Date__c":"'+EsaDate3+'","Estimated_Departure_Date__c":"'+Esdate4+'","Medically_Allowable_Mode_of_Transport__c":"'+MedicallyAllowableModeofTransport+'","Recommended_Mode_of_Transportation__c":"'+RecommendedModeofTransportation+'","Evaluation_Date_and_Time__c":"'+EvalDate8+'"}';
                          	System.debug('POC Insert with out evaluation date2:'+jsonstrHDP);
                    
                        }
                        
                    Http httpobj3 = new Http();
                    HttpRequest req1 = new HttpRequest();
                    req1.setHeader('Authorization','Bearer ' + accessToken);
                    req1.setHeader('Content-Type','application/json');
                    req1.setHeader('accept','application/json');
                    req1.setHeader('charset', 'utf-8');
                    req1.setHeader('Accept-Encoding', 'gzip');
                    req1.setBody(jsonstrHDP);
                    req1.setMethod('POST');
                    req1.setEndpoint(endPoint);
                    HttpResponse res1 = httpobj3.send(req1);
                    string strResponse=res1.getBody();
                    system.Debug('result is:'+strResponse);
                    system.Debug('getStatusCode is:'+res1.getStatusCode());  
                    if (res1.getStatusCode() == 204)
                    {    
                        
                        try{
                            
                            COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'Plan Of Care successfully updated in the customer environment');
                            AM_Plan_Of_Care__c planofc = [select Successfully_Sent_to_HDP__c,Successfully_Sent_to_HDP_Date_Time__c from AM_Plan_Of_Care__c where id=:planID ];
                            planofc.Successfully_Sent_to_HDP__c=true;
                            planofc.Successfully_Sent_to_HDP_Date_Time__c=system.now();
                            update planofc;
                           
                        	}
                        catch(Exception e)
                        {
                            if(e.getMessage()!=null)
                            {
                                COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred: ' + e.getMessage());
                            }
                        }
                    }
                    else
                    {
                        if(string.isNotBlank(strResponse))
                        {
                            COHGoldenToHdpRestApiCall.simpleTextPost(awobj.Chatterid, 'An error has occurred: ' + strResponse);
                        }
                        
                    }
                    }
            }
        }
    }
    
    public static void simpleTextPost(Id objId, String postText) 
    { 
        FeedItem post = new FeedItem();
        post.ParentId = objId; //eg. Opportunity id, custom object id..
        post.Body = postText;
        insert post;
    }
}