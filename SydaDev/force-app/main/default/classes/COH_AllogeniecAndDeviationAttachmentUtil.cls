public class COH_AllogeniecAndDeviationAttachmentUtil {

    // Changes Date 08/27/2017 By Sanjay
    //changes  - Sanjay  01/30/2018
    private static final String SECOND_ALLOGENIC_REQUEST = 'Second_Allogeneic_Request__c';
    //private static final String mOwnerEmailAddr = 'abkumar@coh.org';
    private static string allogenicKeyPrefix = Second_Allogeneic_Request__c.sobjecttype.getDescribe().getKeyPrefix();
    private static string deviatonKeyPrefix = Deviations__c.sobjecttype.getDescribe().getKeyPrefix();
    private static String queryForSAR = 'Select Id, Name, Staff_Name__c,MRN__c,CreatedBy.Email, Staff_Name__r.Name, Email_Sent__c,Patient_Donor_Name__c,Patient_Donor_Name__r.Name,'+ 
                                   'COH_1st_Transplant_Date__c,COH_1st_Transplant_Regimen__c,COH_1st_Transplant_Source__c,COH_1st_Transplant_Type__c,Age__c,Gender__c,' +
                                    'COH_2nd_Transplant_Planned_Regimen__c,COH_2nd_Transplant_Source__c,COH_2nd_Transplant_Type__c,Criteria_1__c,Relapsed_Time_Subsequent_Treatment__c,Current_Disease_Status_and_Plan__c,'+
                                    'Requesting_MD__c,Requesting_MD__r.Name,Criteria_2__c,Criteria_3__c,Criteria_4__c,Criteria_5__c,Criteria_6__c,Criteria_7__c,Criteria_8__c,Criteria_9__c,'+
                                    'Criteria_10__c,Date_of_Planned_2nd_Transplant__c,Reviewer_Summary__c,Adequate_organ_function_comment__c,'+
                                    'Adequate_organ_function_Yes_No__c,Approved_by_ID_comment__c,Approved_by_ID_Yes_No__c,BMBX_30_blast_and_no_PB_blast_comment__c,'+
                                    'BMBX_30_blast_and_no_PB_blast_Yes_No__c,BMBX_within_2weeks_of_2nd_HCT_comment__c,BMBX_within_2weeks_of_2nd_HCT_Yes_No__c,'+
                                    'Insurance_authorized_2nd_HCT_comment__c,Insurance_authorized_2nd_HCT_Yes_No__c,KPS_60_or_ECOG_2_comment__c,KPS_60_or_ECOG_2_Yes_No__c,'+
                                    'No_active_infection_comment__c,No_active_infection_Yes_No__c,Remission_Post_comment__c,Remission_Post_Yes_No__c,Suitable_donor_available_comment__c,'+
                                    'Suitable_donor_available_Yes_No__c,X6month_since_1st_HCT_comment__c,X6month_since_1st_HCT_Yes_No__c,'+
                                    'CrCl__c,EF__c,PFT__c,Status__c,CC1__c,CC2__c,CC3__c,CC4__c,CC5__c,CC1__r.Email,CC2__r.Email,CC3__r.Email,CC4__r.Email,CC5__r.Email,'+
                                    'CC1__r.IsActive,CC2__r.IsActive,CC3__r.IsActive,CC4__r.IsActive,CC5__r.IsActive From Second_Allogeneic_Request__c';
    
    /* - Sanjay Singh 01/30/2018
     * Create an email message and attach the file in case of lightning experience.  The email will be sent to the address stored
     * in toEmailAddr variable and the owner email is store in ownerEmailAddr.
     * 
     * @param contentLinkList           List of ContentDocumentLink objects .
     * @return                          The email object that will be sent out.
     * 
     */ 
    public static void processSecondAllogenicReqContent(List<ContentDocumentLink> contentLinkList){
        Set<Id> SARIds = new Set<Id>();
        Set<Id> DevIds = new Set<Id>();
        Map<Id, ContentVersion> contentMap = new Map<Id, ContentVersion>();
        Set<Id> contentDocIDs = new Set<Id>();
        for(ContentDocumentLink cdl: contentLinkList){
            string key = String.valueOf(cdl.LinkedEntityId).substring(0,3);
            if(key == allogenicKeyPrefix){
                SARIds.add(cdl.LinkedEntityId);
                contentDocIDs.add(cdl.ContentDocumentId);
            }else if(key == deviatonKeyPrefix){
                DevIds.add(cdl.LinkedEntityId);
                contentDocIDs.add(cdl.ContentDocumentId);
            }
        }
        
        
        if(!contentDocIDs.isEmpty()){
            
            For(ContentVersion cv : [SELECT Id, ContentDocumentId, ContentUrl, ContentBodyId, Title, ReasonForChange, 
                                            Description, VersionData, LastModifiedDate, FileType, FileExtension FROM ContentVersion 
                                      Where ContentDocumentId in : contentDocIDs
                                      order by LastModifiedDate DESC]){
                                          
                if(!contentMap.containsKey(cv.ContentDocumentId)){
                    contentMap.put(cv.ContentDocumentId, cv);
                } 
            }
        }
        
        if(!SARIds.isEmpty()){
            processSARContent(SARIds, contentLinkList, contentMap);
            
        }
        
        if(!DevIds.isEmpty()){
            processDeviationContent(DevIds, contentLinkList, contentMap);
            
        }
        
    }
    
  
    
    /* - Sanjay  01/30/2018
     * Create an email message and attach the file in case of lightning experience.  The email will be sent to the address stored
     * in toEmailAddr variable and the owner email is store in ownerEmailAddr.
     * 
     * @param SARIds           Set of Second Allogenic Request Ids
     * @param cdlList          List of ContentDocumentLink records
     * @param contentMap       Map of content DOcument id and ContentVersion
     * @return                 NA
     * 
     */ 
    private static void processSARContent(Set<Id> SARIds , List<ContentDocumentLink> cdlList, Map<Id, ContentVersion> contentMap){
        String getSOQLQuery = queryForSAR + ' where id in : SARIds';
        List<Second_Allogeneic_Request__c> temp = Database.query(getSOQLQuery) ;
        Map<Id, Second_Allogeneic_Request__c> sarMap =  new Map<Id, Second_Allogeneic_Request__c>(temp);
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        List<Second_Allogeneic_Request__c> secAllogenReqList = new List<Second_Allogeneic_Request__c>();
        for(ContentDocumentLink cdl : cdlList){
            if(contentMap.containsKey(cdl.ContentDocumentId) && sarMap.containsKey(cdl.LinkedEntityId) && 
                    sarMap.get(cdl.LinkedEntityId).Email_Sent__c == false && sarMap.get(cdl.LinkedEntityId).Staff_Name__c != null){
               
                Messaging.SingleEmailMessage emailMessage = createEmailMessageForSecondAllogenicReq(sarMap.get(cdl.LinkedEntityId), contentMap.get(cdl.ContentDocumentId));                    
                emailsList.add(emailMessage); 
                sarMap.get(cdl.LinkedEntityId).Email_Sent__c = true; 
            }
        }
        
        try {
            if (COHUtil.isValidList(emailsList)) {
                Messaging.sendEmail(emailsList);
                upsert sarMap.Values();
            }
        } catch (Exception e) {
            throw new COHException('processSecondAllogenicReqAttachmets(): Could not send emails: ' + e.getMessage());
        }
    }
    
    /* - Sanjay  01/30/2018
     * Create an email message and attach the file in case of lightning experience.  The email will be sent to the address stored
     * in toEmailAddr variable and the owner email is store in ownerEmailAddr.
     * 
     * @param SARIds           Set of Deviation Request Ids
     * @param cdlList          List of ContentDocumentLink records
     * @param contentMap       Map of content DOcument id and ContentVersion
     * @return                 NA
     * 
     */ 
      /* Added by Sanjay for High risk project, Overall_DRI_Assignments__c, HCT_High_Risk_Review__c fields */
     
    public static void processDeviationContent(Set<Id> DevIds , List<ContentDocumentLink> cdlList, Map<Id, ContentVersion> contentMap){
        String getDeviationSOQLQuery = 'Select id, Name, Staff_Name__c,MRN__c,Email_Sent__c, CC1__c, CC2__c, CC3__c, CC4__c, CC5__c,' +
                                       'Overall_DRI_Assignments__c, HCT_High_Risk_Review__c, '+ 
                                       'Peds_HCT__c, Date_of_Planned_Transplant__c, Lab_or_Tests__c,Patient_Donor_Name__c, Type__c, Regimen__c, If_applicable_Conditions_Status__c,' +
                                       'Source__c, Team_Name__c,Off_protocol__c,Off_SOC_regimen__c,Requesting_MD__c,Requesting_MD__r.Name,Description_of_deviation__c, Proposed_plan_of_care__c, Patient_Donor_Name__r.Name, ' +
                                       'Staff_Name__r.Name,Additional_Comments__c,Policy__c,Policy_Other__c from Deviations__c  where id in : DevIds';
        List<Deviations__c> temp = Database.query(getDeviationSOQLQuery);
        Map<Id, Deviations__c> devMap =  new Map<Id, Deviations__c>(temp);
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(ContentDocumentLink cdl : cdlList){
            if(contentMap.containsKey(cdl.ContentDocumentId) && devMap.containsKey(cdl.LinkedEntityId) && 
                    devMap.get(cdl.LinkedEntityId).Email_Sent__c == false && devMap.get(cdl.LinkedEntityId).Staff_Name__c != null){
                
                Messaging.SingleEmailMessage emailMessage = createEmailMessageForDeviation(devMap.get(cdl.LinkedEntityId), contentMap.get(cdl.ContentDocumentId));                    
                
                emailsList.add(emailMessage); 
                devMap.get(cdl.LinkedEntityId).Email_Sent__c = true; 
            }
        }
        try {
            if (COHUtil.isValidList(emailsList)) {
                Messaging.sendEmail(emailsList);
                upsert devMap.Values();
            }
        } catch (Exception e) {
            throw new COHException('processSecondAllogenicReqAttachmets(): Could not send emails: ' + e.getMessage());
        }
        
    }
    
    /* - Sanjay  01/30/2018
     * Method to process attachment for second allogenic request in case of attachment sobject insertion
     * 
     * @param attachmentList   List of Attachments
     * @return                 NA
     * 
     */ 
    public static void processSecondAllogenicReqAttachmets(List<Attachment> attachmentList){
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        List<Second_Allogeneic_Request__c> secAllogenReqList = new List<Second_Allogeneic_Request__c>();
        if (COHUtil.isValidList(attachmentList)) {
            Set<Id> parentIDList = new Set<Id>();
            for (Attachment attachmentObj : attachmentList)  {
                Id parentID = attachmentObj.ParentId;
                parentIDList.add(parentID);
            }    
            String getSOQLQuery = queryForSAR + ' where id in : parentIDList';
            
            secAllogenReqList =   Database.query(getSOQLQuery);
            If (COHUtil.isValidList(secAllogenReqList)) {
                
                if(secAllogenReqList[0].Email_Sent__c == false && secAllogenReqList[0].Staff_Name__c != null){
                    Messaging.SingleEmailMessage emailMessage = createEmailMessageForSecondAllogenicReq(secAllogenReqList[0], attachmentList);                    
                    emailsList.add(emailMessage); 
                    secAllogenReqList[0].Email_Sent__c = true;                
                }
            }
        }
        try {
            if (COHUtil.isValidList(emailsList)) {
                Messaging.sendEmail(emailsList);
                upsert secAllogenReqList;
            }
        } catch (Exception e) {
            throw new COHException('processSecondAllogenicReqAttachmets(): Could not send emails: ' + e.getMessage());
        }
    }
    
    
    /* - Sanjay  01/30/2018
     * Method to crete email for Second allogenic request object for both content and attachment sObject
     * 
     * @param secondAllogReq   Second Allogenic request record
     * @return                 Messaging.SingleEmailMessage Email msg
     * 
     */ 
    private static Messaging.SingleEmailMessage createCommonEmailMsgForSAR(Second_Allogeneic_Request__c secondAllogReq){
        Messaging.SingleEmailMessage email = null;
        if (secondAllogReq != null) {
            String textBody = buildEmailTextBodyForSecondAllogenicReq(secondAllogReq);
            if (textBody != null) {
                email = new Messaging.SingleEmailMessage();
                //email.setReplyTo(mOwnerEmailAddr);
                List<String> toEmailAddresses = new List<String>();
                // Changes by sanjay - date -04/30/2018
                List<String> ccEmailAddresses = new List<String>{'dl-hct2ndallocommittee@coh.org'};
                if(secondAllogReq.Staff_Name__c !=null){
                    User objUser = [Select id, Name, Email from User where id = :secondAllogReq.Staff_Name__c and IsActive=true limit 1];      
                    if(objUser !=null)
                    {
                        toEmailAddresses.add(objUser.Email);
                    }
                    
                    if(String.isNotBlank(secondAllogReq.CreatedBy.Email)){
                        ccEmailAddresses.add(secondAllogReq.CreatedBy.Email);
                    }
                   if(secondAllogReq.CC1__c!= null && secondAllogReq.CC1__r.IsActive ){
                        ccEmailAddresses.add(secondAllogReq.CC1__r.Email);
                    }
                   if(secondAllogReq.CC2__c!= null && secondAllogReq.CC1__r.IsActive ){
                        ccEmailAddresses.add(secondAllogReq.CC2__r.Email);
                    }
                    if(secondAllogReq.CC3__c!= null && secondAllogReq.CC1__r.IsActive ){
                        ccEmailAddresses.add(secondAllogReq.CC3__r.Email);
                    }
                    if(secondAllogReq.CC4__c!= null && secondAllogReq.CC1__r.IsActive ){
                        ccEmailAddresses.add(secondAllogReq.CC4__r.Email);
                    }
                    if(secondAllogReq.CC5__c!= null && secondAllogReq.CC1__r.IsActive ){
                        ccEmailAddresses.add(secondAllogReq.CC5__r.Email);
                    }  
                        
                    if(secondAllogReq.Requesting_MD__c !=null) {
                        User objContact = [Select id,  Email from User where id = :secondAllogReq.Requesting_MD__c limit 1];      
                        if(objContact !=null && objContact.Email != null){
                            toEmailAddresses.add(objContact.Email);
                        }
                    }
                }
               
                email.setToAddresses(toEmailAddresses);  
                email.setCcAddresses(ccEmailAddresses);            
                String emailSubject = secondAllogReq.Name + 'Second Allogenic Request submitted';
                email.Subject = emailSubject;
                email.setHTMLBody(textBody);
            }
        }
        return email;
    }
    
    /* - Sanjay  01/30/2018
     * Method to create email for Second allogenic request object  in case of content
     * 
     * @param secondAllogReq    Second Allogenic request record
     * @param content           content record
     * @return                  Messaging.SingleEmailMessage Email msg
     * 
     */ 
    private static Messaging.SingleEmailMessage createEmailMessageForSecondAllogenicReq(Second_Allogeneic_Request__c secondAllogReq, 
                    ContentVersion content){
        Messaging.SingleEmailMessage email ;
        if (secondAllogReq != null) {
            email = createCommonEmailMsgForSAR(secondAllogReq);
            if(email != null){
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(content.title + '.'+content.FileExtension );
                efa.setBody(content.VersionData);
                //efa.setContentType(content.FileType);
                efa.setInline(false);
                email.setFileAttachments(new List<Messaging.EmailFileAttachment>{efa});
            }
        }
        return email;
        
    }
    
    /* - Sanjay  08/27/2017
       - Updated by Sanjay 09/16/2017 -- Added CC addresses
       - Update Sanjay  01/30/2018
     * Create an email message and attach the Attachment.  The email will be sent to the address stored
     * in toEmailAddr variable and the owner email is store in ownerEmailAddr.
     * 
     * @param secondAllogReq            The parent  Second Allogenic Request object for the Questionnaire
     * @param attachList                The List of Attachment objects to send.
     * @return                          The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createEmailMessageForSecondAllogenicReq(Second_Allogeneic_Request__c secondAllogReq, List<Attachment> attachList) {
        
        Messaging.SingleEmailMessage email ;
        if (secondAllogReq != null) {
            email = createCommonEmailMsgForSAR(secondAllogReq);
            if(email != null){
                if (COHUtil.isValidList(attachList)) {
                    List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
                    for (Attachment attachmentObj : attachList) {
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(attachmentObj.Name);
                        efa.setBody(attachmentObj.Body);
                        efa.setContentType(attachmentObj.ContentType);
                        efa.setInline(false);
                        attachmentList.add(efa);
                    }
                    email.setFileAttachments(attachmentList);
                } 
            }
        }
        
        return email;
    }
    
    /* - Sanjay 08/27/2017
    update  - Sanjay  01/30/2018
     * Create the email text body for sending the Second Allogenic Req email.
     * 
     * @param secAllogenicReq               The parent Allogenic Request object
     * @param attachList                    The List of Attachment objects to send.
     * @return                              The text of the email body.
     * 
     */
    private static String buildEmailTextBodyForSecondAllogenicReq(Second_Allogeneic_Request__c secAllogenicReq) {
        String textBody = null;
        if (secAllogenicReq!= null) {
            //Changes in Email body -- By Sanjay , Date -09/19/2017
            String textBody0 = '<body style="">Dear 2nd Allogeneic Committee,<br/><br/><center><table cellpadding="0" width="500" cellspacing="0" id="topTable">' +
                '<tr valign="top"><td style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:middle;">' +
                '<br><b><u><font size="+1">Second Allogeneic Request submitted</font></u></b>';

            String textBody1 = '<br>'; 
                if(secAllogenicReq.Name != null){ 
                    textBody1 += '<br>Second Allogeneic Request ID#:&nbsp' + '<b>' + secAllogenicReq.Name + '</b>';                  
                } 
                if(secAllogenicReq.Staff_Name__c != null){ 
                    textBody1 += '<br>Staff Name:&nbsp' + '<b>' + secAllogenicReq.Staff_Name__r.Name + '</b>';                  
                }
                if(secAllogenicReq.MRN__c != null){ 
                    textBody1 += '<br>MRN:&nbsp' + '<b>' + secAllogenicReq.MRN__c + '</b>';                  
                } 
                if(secAllogenicReq.Patient_Donor_Name__c != null){ 
                    textBody1 += '<br>Patient Name:&nbsp' + '<b>' + secAllogenicReq.Patient_Donor_Name__r.Name + '</b>';                  
                } 
                if(secAllogenicReq.Date_of_Planned_2nd_Transplant__c != null){ 
                    textBody1 += '<br>Date of Planned 2nd Transplant:&nbsp' + '<b>' + secAllogenicReq.Date_of_Planned_2nd_Transplant__c.format() + '</b>';                  
                } 
                if(secAllogenicReq.COH_2nd_Transplant_Type__c != null){ 
                    textBody1 += '<br>2nd Transplant Type:&nbsp' + '<b>' + secAllogenicReq.COH_2nd_Transplant_Type__c + '</b>';                  
                }
                if(secAllogenicReq.Requesting_MD__c != null){ 
                   textBody1 += '<br>MD Requesting:&nbsp' + '<b>' + secAllogenicReq.Requesting_MD__r.Name + '</b>';
                }
                if(secAllogenicReq.COH_2nd_Transplant_Source__c != null){ 
                    textBody1 += '<br>2nd Transplant Type Source:&nbsp' + '<b>' + secAllogenicReq.COH_2nd_Transplant_Source__c + '</b>';                  
                }
                if(secAllogenicReq.COH_2nd_Transplant_Planned_Regimen__c != null){ 
                    textBody1 += '<br>2nd Transplant Planned Regimen:&nbsp' + '<b>' + secAllogenicReq.COH_2nd_Transplant_Planned_Regimen__c + '</b>';                  
                }
                 if(secAllogenicReq.COH_1st_Transplant_Date__c != null){ 
                    textBody1 += '<br>1st Transplant Date:&nbsp' + '<b>' + secAllogenicReq.COH_1st_Transplant_Date__c.format() + '</b>';                  
                } 
                if(secAllogenicReq.COH_1st_Transplant_Type__c != null){ 
                    textBody1 += '<br>1st Transplant Type:&nbsp' + '<b>' + secAllogenicReq.COH_1st_Transplant_Type__c + '</b>';                  
                }
                if(secAllogenicReq.COH_1st_Transplant_Source__c != null){ 
                    textBody1 += '<br>1st Transplant Type Source:&nbsp' + '<b>' + secAllogenicReq.COH_1st_Transplant_Source__c + '</b>';                  
                }
                if(secAllogenicReq.COH_1st_Transplant_Regimen__c != null){ 
                    textBody1 += '<br>1st Transplant Regimen:&nbsp' + '<b>' + secAllogenicReq.COH_1st_Transplant_Regimen__c + '</b>';                  
                } 
                if(secAllogenicReq.Age__c != null){ 
                    textBody1 += '<br>Age:&nbsp' + '<b>' + secAllogenicReq.Age__c + '</b>';                  
                }   
                if(secAllogenicReq.Gender__c != null){ 
                    textBody1 += '<br>Gender:&nbsp' + '<b>' + secAllogenicReq.Gender__c + '</b>';                  
                }
                if(secAllogenicReq.Relapsed_Time_Subsequent_Treatment__c != null){ 
                    textBody1 += '<br>Relapsed Time / Subsequent Treatment:&nbsp' + '<b>' + secAllogenicReq.Relapsed_Time_Subsequent_Treatment__c + '</b>';                  
                }
                if(secAllogenicReq.Current_Disease_Status_and_Plan__c != null){ 
                    textBody1 += '<br>Current Disease Status and Plan:&nbsp' + '<b>' + secAllogenicReq.Current_Disease_Status_and_Plan__c + '</b>';                  
                }
                if(secAllogenicReq.CrCl__c != null){ 
                    textBody1 += '<br>CrCl:&nbsp' + '<b>' + secAllogenicReq.CrCl__c + '</b>';
                }    
                if(secAllogenicReq.EF__c != null){ 
                    textBody1 += '<br>EF:&nbsp' + '<b>' + secAllogenicReq.EF__c + '</b>';
                }        
                if(secAllogenicReq.PFT__c != null){ 
                    textBody1 += '<br>PFT:&nbsp' + '<b>' + secAllogenicReq.PFT__c + '</b>';                                      
                } 
                if(secAllogenicReq.Criteria_1__c != null){ 
                    textBody1 += '<br>Criteria 1:&nbsp' + '<b>' + secAllogenicReq.Criteria_1__c + '</b>';                  
                } 
                if(secAllogenicReq.Remission_Post_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.Remission_Post_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.Remission_Post_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.Remission_Post_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_2__c != null){ 
                    textBody1 += '<br>Criteria 2:&nbsp' + '<b>' + secAllogenicReq.Criteria_2__c + '</b>';                  
                } 
                if(secAllogenicReq.Suitable_donor_available_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.Suitable_donor_available_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.Suitable_donor_available_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.Suitable_donor_available_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_3__c != null){ 
                    textBody1 += '<br>Criteria 3:&nbsp' + '<b>' + secAllogenicReq.Criteria_3__c + '</b>';                  
                } 
                if(secAllogenicReq.Adequate_organ_function_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.Adequate_organ_function_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.Adequate_organ_function_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.Adequate_organ_function_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_4__c != null){ 
                    textBody1 += '<br>Criteria 4:&nbsp' + '<b>' + secAllogenicReq.Criteria_4__c + '</b>';                  
                } 
                if(secAllogenicReq.KPS_60_or_ECOG_2_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.KPS_60_or_ECOG_2_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.KPS_60_or_ECOG_2_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.KPS_60_or_ECOG_2_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_5__c != null){ 
                    textBody1 += '<br>Criteria 5:&nbsp' + '<b>' + secAllogenicReq.Criteria_5__c + '</b>';                  
                } 
                if(secAllogenicReq.No_active_infection_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.No_active_infection_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.No_active_infection_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.No_active_infection_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_6__c != null){ 
                    textBody1 += '<br>Criteria 6:&nbsp' + '<b>' + secAllogenicReq.Criteria_6__c + '</b>';                  
                } 
                if(secAllogenicReq.Approved_by_ID_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.Approved_by_ID_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.Approved_by_ID_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.Approved_by_ID_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_7__c != null){ 
                    textBody1 += '<br>Criteria 7:&nbsp' + '<b>' + secAllogenicReq.Criteria_7__c + '</b>';                  
                } 
                if(secAllogenicReq.X6month_since_1st_HCT_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.X6month_since_1st_HCT_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.X6month_since_1st_HCT_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.X6month_since_1st_HCT_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_8__c != null){ 
                    textBody1 += '<br>Criteria 8:&nbsp' + '<b>' + secAllogenicReq.Criteria_8__c + '</b>';                  
                } 
                if(secAllogenicReq.Insurance_authorized_2nd_HCT_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.Insurance_authorized_2nd_HCT_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.Insurance_authorized_2nd_HCT_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.Insurance_authorized_2nd_HCT_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_9__c != null){ 
                    textBody1 += '<br>Criteria 9:&nbsp' + '<b>' + secAllogenicReq.Criteria_9__c + '</b>';                  
                } 
                if(secAllogenicReq.BMBX_within_2weeks_of_2nd_HCT_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.BMBX_within_2weeks_of_2nd_HCT_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.BMBX_within_2weeks_of_2nd_HCT_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.BMBX_within_2weeks_of_2nd_HCT_comment__c + '</b>';                  
                }
                if(secAllogenicReq.Criteria_10__c != null){ 
                    textBody1 += '<br>Criteria 10:&nbsp' + '<b>' + secAllogenicReq.Criteria_10__c + '</b>';                  
                } 
                if(secAllogenicReq.BMBX_30_blast_and_no_PB_blast_Yes_No__c != null){ 
                    textBody1 += '<br>Yes/No:&nbsp' + '<b>' + secAllogenicReq.BMBX_30_blast_and_no_PB_blast_Yes_No__c + '</b>';                  
                }
                if(secAllogenicReq.BMBX_30_blast_and_no_PB_blast_comment__c != null){ 
                    textBody1 += '<br>Comment:&nbsp' + '<b>' + secAllogenicReq.BMBX_30_blast_and_no_PB_blast_comment__c + '</b>';                  
                }
                
                                       
            String recURL = URL.getSalesforceBaseURL().toExternalForm() + '/one/one.app?source=aloha#/sObject/'+secAllogenicReq.Id+'/view/' ;
            String textBody2 = '<br><br> <a href="' + recURL + '">' + 'Click Here To Access This request'  + '</a> ';
            
            textBody = textBody0 + textBody1 + textBody2 + '</td></tr></table></center></body>';
        }    
        return textBody;
    }
    
     /* - Abhishek 05/31/2017
     update  - Sanjay  01/30/2018
     * Process attachments for deviation object.
     * 
     * @param deviationAttachmentList   List of attachments for deviation
     * 
     */
    public static void processDeviationAttachments(List<Attachment> deviationAttachmentList) {
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        List<Deviations__c> deviationList;
        if (COHUtil.isValidList(deviationAttachmentList) ) {
            List<Id> parentIDList = new List<Id>();
            for (Attachment attachmentObj : deviationAttachmentList)  {
                Id parentID = attachmentObj.ParentId;
                parentIDList.add(parentID);
            }
            
            String getDeviationSOQLQuery = 'Select id, Name, Staff_Name__c,MRN__c,Email_Sent__c, CC1__c, CC2__c, CC3__c, CC4__c, CC5__c,' +
                                           'Overall_DRI_Assignments__c, HCT_High_Risk_Review__c, '+
                                           'Peds_HCT__c, Date_of_Planned_Transplant__c, Lab_or_Tests__c,Patient_Donor_Name__c, Type__c, Regimen__c, If_applicable_Conditions_Status__c,' +
                                           'Source__c, Requesting_MD__c,Requesting_MD__r.Name,Description_of_deviation__c, Proposed_plan_of_care__c, Patient_Donor_Name__r.Name, ' +
                                           'Staff_Name__r.Name,Additional_Comments__c,Policy__c,Policy_Other__c from Deviations__c  where id in : parentIDList';
            deviationList = Database.query(getDeviationSOQLQuery);
            
            If (COHUtil.isValidList(deviationList)) {
                if(deviationList[0].Email_Sent__c == false && deviationList[0].Staff_Name__c != null)
                {
                    Messaging.SingleEmailMessage emailMessage = createEmailMessageForDeviation(deviationList[0], deviationAttachmentList);                    
                    emailsList.add(emailMessage); 
                    deviationList[0].Email_Sent__c = true;                
                }
            }
            
             /*for (Attachment attachmentObj : questionnaireAttachmentList)  {
                 Id parentID = attachmentObj.ParentId;
                 String getQuestionnaireSOQLQuery = 'select Id, Name, RecordTypeId, Are_the_materials_mice__c, COH_PI__c, ' + 
                     'COH_PI_Department__c, COH_PI_Name__c, Describe_the_handling_precautions_txt__c, Describe_the_handling_precautions__c, ' +  
                     'Do_you_request_special_conditions__c, Federal_Funding__c, Include_human_materials_biospecimens__c, Incoming_transfer__c, ' +  
                     'Industrial_support__c, IQ1_Document__c, Is_it_Radioactive__c, Is_the_Material_a_pathogen__c, ' +  
                     'Material_as_a_gift_or_under_a_MTA__c, Material_contain_or_generate_viruses__c, Material_contain_plant_animal_pathogen__c, Material_derived_from__c, ' +  
                     'Material_obtained_from_human_subjects__c, Name_and_Description_of_Material_s__c, Name_of_Lab_Company__c, Outgoing_transfer__c, ' +  
                     'PI_Email_address__c, PI_s_permission_to_request_the_transfer__c, Please_describe_Another_lab_or_Company__c, Please_describe_Material_as_a_gift__c, ' +  
                     'Please_list_out_award_contract_number__c, Please_list_out_grant_number__c, Please_name_the_Industry_partner__c, Preferred_Citation_No_Publication__c, ' +  
                     'Preferred_Citation_PMID__c, Providing_Institution__c, Providing_Scientist_if_applicable__c, select_buildings_where_activity_occur__c, ' +  
                     'Special_conditions_Description__c, Subaward_or_subcontract__c, Submitting_person_s_PI_Name__c, What_BSL_level_is_it_used_under__c, ' +  
                     'Where_will_the_research_be_conducted_e__c, Will_any_industrial_support_fund_any_par__c, Will_the_provider_be_sending_employees_o__c from Questionnaire__c where id=:parentID limit 1';
                 List<Questionnaire__c> questionnaireList = Database.query(getQuestionnaireSOQLQuery);
                 if (questionnaireList != null && questionnaireList.size() > 0 && mMTAQuestionnaireRecordTypeID == questionnaireList[0].RecordTypeId)
                 {
                     Messaging.SingleEmailMessage emailMessage = createEmailMessageForQuestionnaire(questionnaireList[0], questionnaireAttachmentList);                    
                     emailsList.add(emailMessage);
                 }
            }*/
        }
        
        try {
            system.debug('===emailsList===='+emailsList);
            if (COHUtil.isValidList(emailsList)) {
                Messaging.sendEmail(emailsList);
                upsert deviationList;
            }
        } catch (Exception e) {
            throw new COHException('processDeviationAttachments(): Could not send emails: ' + e.getMessage());
        }
    }
    
    /* - Sanjay  01/30/2018
     * common Method to create email for Deviation  object  in case of both content and Attachment
     * 
     * @param deviationsObj     Deviation Record
     * @return                  Messaging.SingleEmailMessage Email msg
     * 
     */ 
    private static Messaging.SingleEmailMessage createCommonEmailMsgForDeviation(Deviations__c deviationsObj){
        Messaging.SingleEmailMessage email = null;
        if (deviationsObj != null) {
            String textBody = buildEmailTextBodyForDeviation(deviationsObj);
            if (textBody != null) {
                email = new Messaging.SingleEmailMessage();
                //email.setReplyTo(mOwnerEmailAddr);
                List<String> toEmailAddresses = new List<String>();
                List<String> ccEmailAddresses = new List<String>();
                if(deviationsObj.Staff_Name__c !=null)
                {
                    User objUser = [Select id, Name, Email from User where id = :deviationsObj.Staff_Name__c and IsActive=true limit 1];      
                    if(objUser !=null)
                    {
                        toEmailAddresses.add(objUser.Email);
                    }
                }
                if(deviationsObj.Requesting_MD__c !=null)
                {
                    User objUser = [Select id, Name, Email from User where id = :deviationsObj.Requesting_MD__c and IsActive=true limit 1];      
                    if(objUser !=null && objUser.Email != null)
                    {
                        toEmailAddresses.add(objUser.Email);
                    }
                }
                if(deviationsObj.CC1__c !=null)
                {
                    User objUserCC1 = [Select id, Name, Email from User where id = :deviationsObj.CC1__c and IsActive=true limit 1];      
                    if(objUserCC1 !=null)
                    {
                        toEmailAddresses.add(objUserCC1.Email);
                    }
                }
                if(deviationsObj.CC2__c !=null)
                {
                    User objUserCC2 = [Select id, Name, Email from User where id = :deviationsObj.CC2__c and IsActive=true limit 1];      
                    if(objUserCC2 !=null)
                    {
                        toEmailAddresses.add(objUserCC2.Email);
                    }
                }
                if(deviationsObj.CC3__c !=null)
                {
                    User objUserCC3 = [Select id, Name, Email from User where id = :deviationsObj.CC3__c and IsActive=true limit 1];      
                    if(objUserCC3 !=null)
                    {
                        toEmailAddresses.add(objUserCC3.Email);
                    }
                }
                if(deviationsObj.CC4__c !=null)
                {
                    User objUserCC4 = [Select id, Name, Email from User where id = :deviationsObj.CC4__c and IsActive=true limit 1];      
                    if(objUserCC4 !=null)
                    {
                        toEmailAddresses.add(objUserCC4.Email);
                    }
                }
                if(deviationsObj.CC5__c !=null)
                {
                    User objUserCC5 = [Select id, Name, Email from User where id = :deviationsObj.CC5__c and IsActive=true limit 1];      
                    if(objUserCC5 !=null)
                    {
                        toEmailAddresses.add(objUserCC5.Email);
                    }
                }
                email.setToAddresses(toEmailAddresses);  
                
                // Changes by Sanjay Singh --04/30/2018
                if(deviationsObj.Peds_HCT__c)
                {
                    // dl-hctdeviationcommittee@coh.org
                    ccEmailAddresses.add('dl-hctpedsdeviationcommittee@coh.org');
                }
                else
                {
                    /**START: CHANGES BY Sanjay 07/25/2022*/
                    if(deviationsObj.Type__c == 'CAR-T'){
                        ccEmailAddresses.add('dl-ccic@coh.org');
                    }
                    else {
                        ccEmailAddresses.add('dl-hctdeviationcommittee@coh.org');//update this when we move to production.
                    }
                    /**END: CHANGES BY Sanjay 07/25/2022*/
                } 
                /* Added by Sanjay for High risk project,HCT_High_Risk_Review__c fields */
                
                if(deviationsObj.HCT_High_Risk_Review__c)
                {
                ccEmailAddresses.add('DL-HCTHighRisk@coh.org');
                }
                // Changes by Sanjay Singh --04/30/2018
                if(!ccEmailAddresses.isEmpty()){
                    email.setCcAddresses(ccEmailAddresses);
                }
                
                String emailSubject = deviationsObj.Name + ' Deviation submitted';
                email.Subject = emailSubject;
                email.setHTMLBody(textBody);
            }
        }
        return email;
    }
    
    /* Sanjay  01/30/2018
     *  Message to create Email for deviation record when inserting content
     * 
     * @param deviationsObj             The parent deviationsObj object for the Questionnaire
     * @param content                   content
     * @return                          The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createEmailMessageForDeviation(Deviations__c deviationsObj, contentVersion content) {
        
        Messaging.SingleEmailMessage email = null;
        if (deviationsObj != null) {
            email = createCommonEmailMsgForDeviation(deviationsObj);
            if (email != null) {
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(content.title + '.'+content.FileExtension );
                efa.setBody(content.VersionData);
                //efa.setContentType(content.FileType);
                efa.setInline(false);
                email.setFileAttachments(new List<Messaging.EmailFileAttachment>{efa});
            } 
            
            
            
        }
        return email;
    }
    
    /* - Abhishek 05/31/2017
        update  - Sanjay  01/30/2018
     * Create an email message and attach the Attachment.  The email will be sent to the address stored
     * in toEmailAddr variable and the owner email is store in ownerEmailAddr.
     * 
     * @param deviationsObj             The parent deviationsObj object for the Questionnaire
     * @param deviationAttachmentList   The List of Attachment objects to send.
     * @return                          The email object that will be sent out.
     * 
     */
    private static Messaging.SingleEmailMessage createEmailMessageForDeviation(Deviations__c deviationsObj, List<Attachment> deviationAttachmentList) {
        
        Messaging.SingleEmailMessage email = null;
        if (deviationsObj != null) {
            email = createCommonEmailMsgForDeviation(deviationsObj);
            if (email != null && COHUtil.isValidList(deviationAttachmentList)) {
                List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
                for (Attachment attachmentObj : deviationAttachmentList) {
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(attachmentObj.Name);
                    efa.setBody(attachmentObj.Body);
                    efa.setContentType(attachmentObj.ContentType);
                    efa.setInline(false);
                    attachmentList.add(efa);
                }
                email.setFileAttachments(attachmentList);
            } 
            
        }
        return email;
    }
    
    
    /* - Abhishek 31/05/2017
     - update Sanjay  01/30/2018
     * Create the email text body for sending the Deviation email.
     * 
     * @param deviationsObj             The parent Deviations object
     * @param deviationAttachmentList   The List of Attachment objects to send.
     * @return                          The text of the email body.
     * 
     */
    private static String buildEmailTextBodyForDeviation(Deviations__c deviationsObj) {
        String textBody = null;
        if (deviationsObj!= null) {

            String textBody0 = '<body style="">Dear HEM/HCT Deviation Committee, <br/><br/><center><table cellpadding="0" width="500" cellspacing="0" id="topTable"' +
                '<tr valign="top"><td style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:middle;">' +
                '<br><b><u><font size="+1">HCT Deviation request submitted</font></u></b>';
			
            /**START: CHANGES BY Sanjay 07/25/2022*/
            if(deviationsObj.Type__c == 'CAR-T'){
                textBody0 = '<body style="">Dear CCIC, <br/><br/><center><table cellpadding="0" width="500" cellspacing="0" id="topTable"' +
                '<tr valign="top"><td style=" background-color:#FFFFFF; bEditID:r1st1; bLabel:header; vertical-align:middle;">' +
                '<br><b><u><font size="+1">An IEC Deviation was submitted.</font></u></b>';
            }
            /**END: CHANGES BY Sanjay 07/25/2022*/
            String textBody1 = '<br>'; 
                if(deviationsObj.Name != null){ 
                    textBody1 += '<br>Deviation ID#:&nbsp' + '<b>' + deviationsObj.Name + '</b>';                  
                } 
                if(deviationsObj.Staff_Name__c != null){ 
                    textBody1 += '<br>Staff Name:&nbsp' + '<b>' + deviationsObj.Staff_Name__r.Name + '</b>';
                }
                if(deviationsObj.team_name__c != null){ 
                    textBody1 += '<br>Team Name:&nbsp' + '<b>' + deviationsObj.team_name__c + '</b>';
                }
                                
                if(deviationsObj.Patient_Donor_Name__c != null){ 
                    textBody1 += '<br>Patient/Donor Name:&nbsp' + '<b>' + deviationsObj.Patient_Donor_Name__r.Name + '</b>';                 
                }
                if(deviationsObj.MRN__c != null){ 
                    textBody1 += '<br>MRN:&nbsp' + '<b>' + deviationsObj.MRN__c + '</b>';                 
                }
                if(deviationsObj.Date_of_Planned_Transplant__c != null){ 
                    textBody1 += '<br>Date of Planned HCT/Cellular Therapy ?:&nbsp' + '<b>' + deviationsObj.Date_of_Planned_Transplant__c.format() + '</b>';                 
                }      
                if(deviationsObj.Type__c != null){ 
                    textBody1 += '<br>Type:&nbsp' + '<b>' + deviationsObj.Type__c + '</b>';                 
                }
                if(deviationsObj.Regimen__c != null){ 
                    textBody1 += '<br>Regimen:&nbsp' + '<b>' + deviationsObj.Regimen__c + '</b>';                 
                }
                if(deviationsObj.Source__c != null){ 
                    textBody1 += '<br>Source:&nbsp' + '<b>' + deviationsObj.Source__c + '</b>';                 
                }
                if(deviationsObj.Requesting_MD__c != null){ 
                   // textBody1 += '<br>MD Requesting:&nbsp' + '<b>' + deviationsObj.Requesting_MD__c + '</b>';
                   textBody1 += '<br>MD Requesting:&nbsp' + '<b>' + deviationsObj.Requesting_MD__r.Name + '</b>';                 
                }
                if(deviationsObj.Policy__c != null){ 
                    textBody1 += '<br>Policy:&nbsp' + '<b>' + deviationsObj.Policy__c + '</b>';                 
                }
                if(deviationsObj.Policy_Other__c != null){ 
                    textBody1 += '<br>Policy(Other):&nbsp' + '<b>' + deviationsObj.Policy_Other__c + '</b>';                 
                }
                if(deviationsObj.Off_protocol__c != null){ 
                    textBody1 += '<br>Off protocol:&nbsp' + '<b>' + deviationsObj.Off_protocol__c + '</b>';                 
                }
                if(deviationsObj.Off_SOC_regimen__c != null){ 
                    textBody1 += '<br>Off SOC regimen:&nbsp' + '<b>' + deviationsObj.Off_SOC_regimen__c + '</b>';                 
                }
                                            
                if(deviationsObj.Description_of_deviation__c != null){ 
                    textBody1 += '<br>Background:&nbsp' + '<b>' + deviationsObj.Description_of_deviation__c + '</b>';                 
                }
                if(deviationsObj.Proposed_plan_of_care__c != null){ 
                    textBody1 += '<br>Planned deviation:&nbsp' + '<b>' + deviationsObj.Proposed_plan_of_care__c + '</b>';                 
                }
                if(deviationsObj.Additional_Comments__c != null){ 
                    textBody1 += '<br>Additional Comments:&nbsp' + '<b>' + deviationsObj.Additional_Comments__c + '</b>';                 
                }
                /* Added by Sanjay for High risk project, Overall_DRI_Assignments__c, HCT_High_Risk_Review__c fields */
                if(deviationsObj.Overall_DRI_Assignments__c != null){ 
                textBody1 += '<br>Overall DRI Assignments:&nbsp' + '<b>' + deviationsObj.Overall_DRI_Assignments__c + '</b>';                 
                }
                               
            String deviationsURL = URL.getSalesforceBaseURL().toExternalForm() + '/one/one.app?source=aloha#/sObject/'+ deviationsObj.Id+'/view/' ;
            String textBody2 = '<br><br> <a href="' + deviationsURL + '">' + 'Click Here To Access This Deviation'  + '</a> ';
            
            textBody = textBody0 + textBody1 + textBody2 + '</td></tr></table></center></body>';
        }    
        return textBody;
    }
    
}