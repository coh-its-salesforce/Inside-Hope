/**
 * @author................. Sanjay Singh 
 * @version................ 1.0.0
 * @description.............Helper class of trigger ApplicationRequestTrigger
 *
 *
 **/ 
public with sharing class ApplicationRequestTrigHelper { 

    public  static void doOnApprove(List<New_Application_Request__c> newApplications, 
                                    Map<Id, New_Application_Request__c> oldMap){
        Map<String, BMCServiceDesk__BMC_BaseElement__c> existingBaseElementMap = new Map<String, BMCServiceDesk__BMC_BaseElement__c>();
        Set<String> applicationSet = new Set<String>();
        for(New_Application_Request__c req: newApplications){
            if(String.isNotBlank(req.Application_Name__c)){
                applicationSet.add(req.Application_Name__c);
            }
        }
        // Query Already Existing Base ELement for Update 
        // DO not create new one if already exist
        for(BMCServiceDesk__BMC_BaseElement__c basEle: [Select Id, BMCServiceDesk__Name__c from BMCServiceDesk__BMC_BaseElement__c 
                    where  BMCServiceDesk__Name__c in :applicationSet]){
            existingBaseElementMap.put(basEle.BMCServiceDesk__Name__c, basEle);
        }
        List<BMCServiceDesk__BMC_BaseElement__c> baseElementList = new List<BMCServiceDesk__BMC_BaseElement__c>();
        set<id> userIDSet = new set<id>();
        for(New_Application_Request__c req: newApplications){
            if(req.Business_Owner__c != null){
                userIDSet.add(req.Business_Owner__c);
            }
            if(req.IT_Owner__c != null){
                userIDSet.add(req.IT_Owner__c);
            }
            if(req.IT_Manager__c != null){
                userIDSet.add(req.IT_Manager__c);
            }
            if(req.IT_Director__c != null){
                userIDSet.add(req.IT_Director__c);
            }
            if(req.Secondary_Support_Analyst__c != null){
                userIDSet.add(req.Secondary_Support_Analyst__c);
            }
            if(req.Primary_Support_Analyst__c != null){
                userIDSet.add(req.Primary_Support_Analyst__c);
            }
        }
        Map<Id, User> userMap = new Map<Id, User>([select id,firstName, LastName from User where id in:userIDSet]);
                                        
                                        
        for(New_Application_Request__c req: newApplications){
            // Create/UPdate base element if request approved
            //if(req.Status__c == 'Approved' && oldMap.get(req.Id).status__c != req.Status__c && String.isNotBlank(req.Application_Name__c)){
                if(req.Application_Status__c == 'Approved' && oldMap.get(req.Id).Application_Status__c != req.Application_Status__c && String.isNotBlank(req.Application_Name__c)){
                
                BMCServiceDesk__BMC_BaseElement__c elem = new BMCServiceDesk__BMC_BaseElement__c();
                if (existingBaseElementMap.containsKey(req.Application_Name__c)){
                    elem = existingBaseElementMap.get(req.Application_Name__c);
                }
                elem = createBaseElement(req, elem);
                if(req.Business_Owner__c != null && userMap.containsKey(req.Business_Owner__c)){
                    elem.Business_Owner__c = userMap.get(req.Business_Owner__c).FIrstName + ' '+userMap.get(req.Business_Owner__c).LastName; 
                }
                
                if(req.IT_Owner__c != null && userMap.containsKey(req.IT_Owner__c)){
                    elem.IT_Owner__c = userMap.get(req.IT_Owner__c).FIrstName + ' '+userMap.get(req.IT_Owner__c).LastName; 
                }
                if(req.IT_Manager__c != null && userMap.containsKey(req.IT_Manager__c)){
                    elem.IT_Manager__c = userMap.get(req.IT_Manager__c).FIrstName + ' '+userMap.get(req.IT_Manager__c).LastName; 
                }
                if(req.IT_Director__c != null && userMap.containsKey(req.IT_Director__c)){
                    elem.IT_Director__c = userMap.get(req.IT_Director__c).FIrstName + ' '+userMap.get(req.IT_Director__c).LastName; 
                }
                baseElementList.add(elem);
            }
        }
        System.debug('==baseElementList==='+baseElementList);
        if(!baseElementList.isEmpty()){
            List<Database.UpsertResult> upsertResults= Database.Upsert(baseElementList, false);
            System.debug('==upsertResult==='+upsertResults[0]);
        }
    
    }


    /**
    * @description Create Base Element Object Instance , Map request Field from Application Request Obj
    * @param req- application request obj instance
    * @param elem- BMC base element object Instance 
    * @return Return updatd BMC base element object Instance
    **/ 
    public static BMCServiceDesk__BMC_BaseElement__c createBaseElement(New_Application_Request__c req, 
                                                                        BMCServiceDesk__BMC_BaseElement__c elem){
        elem.Application_Type__c = req.Application_Type__c;
        elem.BMCServiceDesk__ApplicationType__c = req.Application_Type__c;
        elem.BMCServiceDesk__Name__c = req.Application_Name__c;
        elem.Status__c = req.Status__c;
        elem.Automatic_Logoff__c = req.Automatic_Logoff__c;
        elem.Business_Dept__c = req.Business_Department__c;
        elem.Business_Owner__c = req.Business_Owner__c;
        //elem.Business_Owner__c = req.Business_Owner_name__c;
        elem.Comments__c= req.Comments__c;
        //elem.Data_at_Rest_Encryption__c= req.Data_at_Rest_Encryption__c;
        elem.SaaS__c = req.SaaS__c;
        elem.Data_in_Transmission_Encryption__c= req.Data_in_Transmission_Encryption__c;
        elem.BMCServiceDesk__Description__c= req.Description__c;
        elem.Disaster_Recovery_or_Business_Continuity__c= req.Disaster_Recovery_or_Business_Continuity__c;
        elem.Recovery_Point_Objective__c = req.Recovery_Point_Objective__c;
        elem.Recovery_Time_Objective__c= req.Recovery_Time_Objective__c;
        //elem.Data_at_Rest_Encryption__c = req.Data_at_Rest_Encryption__c;
        elem.Emergency_Access_Procedure__c= req.Emergency_Access_Procedure__c;
        elem.Internet_Accessibility__c= req.Internet_Accessibility__c ? 'Yes': 'No';
        elem.Internet_URL__c= req.Internet_URL__c;
        elem.Vendor__c= req.Vendor_Name__c;
        elem.AD_Integrated__c= req.AD_Integrated__c;    
        elem.IT_Manager__c= req.IT_Manager__c;
        //elem.IT_Manager__c= req.IT_Manager_name__c;
        elem.IT_Owner__c= req.IT_Owner__c;
        //elem.IT_Owner__c= req.IT_Owner_name__c;
        elem.Last_Upgrade_Date__c= req.Last_Upgrade_Date__c;
        elem.Logging_Enabled__c= req.Logging_Enabled__c;
        //elem.HIPPA_Data__c= req.HIPPA_Data__c ? 'Yes': 'No';
        elem.PCI_Data__c= req.PCI_Data__c ? 'Yes': 'No';    
        elem.PHI_Data__c= req.PHI_Data__c ? 'Yes': 'No';    
        elem.Primary_Support_Analyst__c= req.Primary_Support_Analyst__c;
        elem.Renewal_Cost__c= req.Renewal_Cost__c;
        elem.Renewal_Date__c= req.Renewal_Date__c;
        elem.Secondary_Support_Analyst__c= req.Secondary_Support_Analyst__c;
        elem.Server_Environments__c= req.Stage_Status__c;
        elem.Tier_Level__c= req.Tier_Level__c;
        elem.Timeouts_Enabled__c= req.Timeouts_Enabled__c;
        elem.Unique_User_Identification__c= req.Unique_User_Identification__c;
        elem.Vendor_Name__c= req.Vendor_Name__c;
        //elem.BMCServiceDesk__CMDB_Class__c = 'a15550000008Qxj';
        elem.BMCServiceDesk__CMDB_Class__c = 'a15d0000000cvZj';                                                                    
        //elem.BMCServiceDesk__ClassID__c= 'BMC_APPLICATION';
        //elem.BMCServiceDesk__ClassName__c= 'BMC_Application';
        //elem.Application_Request__c = req.Id;
        
        //New Fields added By Sanjay : Date - 04/11/2019
        elem.BusinessOwner__c  = req.Business_Owner__c ;
        elem.ITOwner__c  = req.IT_Owner__c ;
        elem.Number_of_Internal_Users__c  = req.Number_of_Internal_Users__c ;
        elem.Number_of_External_Users__c  = req.Number_of_External_Users__c ;
        elem.User_Accessibility__c  = req.User_Accessibility__c ;
        elem.Single_Sign_On__c  = req.Single_Sign_On__c ;                                                                    
        elem.Data_Transfer_Protocol__c = req.Data_Transfer_Protocol__c ;
        elem.Data_Encryption_at_Rest__c = req.Data_Encryption_at_Rest__c ;
        elem.Development_Mode__c = req.Development_Mode__c  ;
        elem.Deployment_Mode__c = req.Deployment_Mode__c  ;
        elem.DR_Available__c  = req.DR_Available__c? 'Yes': 'No';   
        elem.DR_Location__c = req.DR_Location__c;
        //Sanjay Singh Dec 31st 2019 Changed from Picklist to checkbox; 
        //elem.Network_Connectivity_Redundancy__c = req.Network_Connectivity_Redundancy__c;
        elem.DR_Class__c = req.DR_Class__c  ;
        elem.Data_Retention__c = req.Data_Retention__c  ;
        elem.Back_up_Frequency__c = req.Back_up_Frequency__c  ; 
        elem.Data_Classification__c = req.Data_Classification__c  ;
        elem.GxP_Indicator__c = req.GxP_Indicator__c;    
        elem.BMCServiceDesk__Vendor__c = req.Vendor__c ;      
        elem.BMCServiceDesk__Version_Number__c = req.version__c;
        elem.BMCServiceDesk__FKLocation__c = req.Primary_Location__c;
        elem.PHI_Indicator__c = req.PHI_Indicator__c ;
        elem.PCI_Indicator__c = req.PCI_Indicator__c ;
        elem.SOX_Indicator__c = req.SOX_Indicator__c ;
        elem.SaaS__c = req.SaaS__c ;
        elem.BMCServiceDesk__Notes__c = req.Notes__c;
        
        
        //New Fields added By Sanjay : Date - 12/23/2019
        
        elem.IT_Director__c= req.IT_Director__c;
        elem.Infinite_Support_Status__c= req.Infinite_Support_Status__c;
                                                                    
        return elem;
    }
}