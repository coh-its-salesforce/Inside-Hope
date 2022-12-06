/*
Creator:  Frank Salinas
Date:     08/18/2019 
Purpose:  Used for PRS Auto Alert
Ref Doc:  INC00760162
Description: InvocableMethod RestAPI method to read case and determine which auto alert emails need to be sent out.
			 Uses Custom Metadata setting to determine criteria entry and email list
Parameter: Case object. InvocableMethods allow for only one parameter. 
*/
public class PRS_AutoAlert_Emails {
    static PRS_Auto_Alert_Setting__mdt PRS_MDT = new PRS_Auto_Alert_Setting__mdt();
    
    @InvocableMethod(label='Send PRS Auto Alert Emails' description='Sends out email when certain Procurement Statuses hit "All Recieved"')
    public static void SendEmailTemplate(LIST<Case> caseObj) {
        //Grab the Case object values needed
        String ServiceLine = caseObj[0].Service_Line__c;
        String Department = caseObj[0].Department_Case__c;
        Id CaseId = caseObj[0].Id;
        String Account_Name = caseObj[0].Account_Name_Formula__c;
        String MRN = caseObj[0].Acct_MRN_Number__c;//.Account.COH_MRN__c;
        String appt = String.ValueOf(caseObj[0].Appt_Date_Time__c);
        String Owner = caseObj[0].Owner.Name;//Case_Owner_Profile__c;
        String Physician_Decision_Tree = caseObj[0].Physician_Decision_Tree__c;
        Datetime Imaging_Email_Sent = caseObj[0].Auto_Alert_Imaging_Email_Sent__c;
        Datetime Records_Email_Sent = caseObj[0].Auto_Alert_records_Email_Sent__c;
        Datetime Pathology_Email_Sent = caseObj[0].Auto_Alert_pathology_Email_Sent__c;
        String Imaging_Status = caseObj[0].Imaging_Status__c;
        String Records_Status = caseObj[0].MD_Note_Status__c;
        String Pathology_Status = caseObj[0].Pathology_Status__c;
        if (String.IsEmpty(appt)) appt = '';
        if (Account_Name == null) Account_Name = '';
        if (MRN == null) MRN = '';
        if (Owner == null) Owner = '';
        //Emails are only sent if the procurment Status equals "All Received" AND the corresponding "...Email_Sent" flag is null
        LIST<String> EmailStatus = new LIST<String>();
		If (Imaging_Email_Sent == null && Imaging_Status == 'All Received') EmailStatus.add('IMAGING');
		If (Records_Email_Sent == null && Records_Status == 'All Received') EmailStatus.add('RECORDS');
		If (Pathology_Email_Sent == null && Pathology_Status == 'All Received') EmailStatus.add('PATHOLOGY');
        If (EmailStatus.Size() > 0) {
            for (String Status_Document: EmailStatus) {
                system.debug('Status_Document'+Status_Document);
                system.debug('ServiceLine'+ServiceLine); 
                system.debug('Department'+Department);
                system.debug('CaseId'+CaseId);
                system.debug('Account Name'+Account_Name);
                system.debug('MRN'+MRN);
                system.debug('appt'+appt);
                system.debug('Owner'+Owner);
                system.debug('Physician_Decision_Tree'+Physician_Decision_Tree);                
                SendAutoAlertEmail(Status_Document,
                                   ServiceLine, 
                                   Department,
                                   CaseId,
                                   Account_Name,
                                   MRN,
                                   appt,
                                   Owner,
                                   Physician_Decision_Tree);                
            }
            UpdateAutoAlertEmailSent (CaseId, EmailStatus);
        }
        
    }
    
    private static Boolean SendAutoAlertEmail( String Status_Document,
                                            String ServiceLine, 
                                            String Department,
                                            Id CaseId,
                                            String Account_Name,
                                            String MRN,
                                            String appt,
                                            String Owner,
                                          	String Physician_Decision_Tree) {
        //Uses Custom Metadata to determine if the Decision Tree physician/department/serviceline and sends the below email                                        
        Boolean ExitTheFlow = false;//Exits the method if no metadata match is found
        Boolean retBool = false;
        String PRS_MDT_Label = Department.toUpperCase() + '-' + ServiceLine.toUpperCase();
        try {
        	PRS_MDT = [Select Department__c, Emails__c, Service_Line__c, Physicians__c, Email_Template__c, OWA__c
                       From PRS_Auto_Alert_Setting__mdt Where Label = :PRS_MDT_Label];
        } catch (exception e) {
            system.debug('SendEmailTemplate exception getting Metadata: ' + e.getMessage());
            return retBool;
        }
        String OWA_Display_Name = PRS_MDT.OWA__c;
		OrgWideEmailAddress owa = [Select id, DisplayName, Address From OrgWideEmailAddress Where DisplayName = :OWA_Display_Name limit 1];
        String TemplateName = PRS_MDT.Email_Template__c;
		EmailTemplate templateId = [Select id, HTMLValue, Body, Subject from EmailTemplate where name = :TemplateName];
        String Physician = Physician_Decision_Tree;
        list<string> to = TextAreaToList(PRS_MDT.Emails__c);
        list<string> physicians = TextAreaToList(PRS_MDT.Physicians__c);
        system.debug('to='+to);
        system.debug('physicians='+physicians);
        ExitTheFlow = ValidatePhysicians(Physician, physicians);
        if (ExitTheFlow == false) {
            system.debug('SendEmailTemplate ExitTheFlow stops process - could not validate physician '+ physician + ': ExitTheFlow:' + ExitTheFlow);
            return retBool;
        }
		List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId.Id);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setSaveAsActivity(false);
        mail.setOrgWideEmailAddressId(owa.id);

		//Replace text in the Email Template with the correct values
        String subject = Status_Document + ' Documents Received';
        mail.setSubject(subject);
        String htmlBody = templateId.HtmlValue;
        htmlBody =+ htmlBody.replace('{!Case.Account_Name__c}', Account_Name);
        htmlBody =+ htmlBody.replace('{!Case.COH_MRN__c}', MRN);
        htmlBody =+ htmlBody.replace('{!Case.Appt_Date_Time__c}', appt);
        htmlBody =+ htmlBody.replace('{!Case.OwnerFullName}', Owner);
        htmlBody =+ htmlBody.replace('{!Status_Documents}', Status_Document);
        mail.setHtmlBody(htmlBody);	 
        String plainBody = templateId.Body;
        plainBody =+ plainBody.replace('{!Case.Account_Name__c}', Account_Name);
        plainBody =+ plainBody.replace('{!Case.COH_MRN__c}', MRN);
        plainBody =+ plainBody.replace('{!Case.Appt_Date_Time__c}', appt);
        plainBody =+ plainBody.replace('{!Case.OwnerFullName}', Owner);
        plainBody =+ plainBody.replace('{!Status_Documents}', Status_Document);
        mail.setPlainTextBody(plainBody);

        mail.settoaddresses(to);
        allmsg.add(mail);
		system.debug('mail='+mail);
		Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg,false);
        if (results[0].success) {
            System.debug('The ' + Status_Document + ' email was sent successfully.');
            retBool = true;
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            retBool = false;
        }  
		Return retBool;
    }
    
    private static List<String> TextAreaToList(String emails){
        List<String> e = new List<String>();
       	e = emails.split('\n');
        return e;
    }
    
    private static boolean ValidatePhysicians(String physician, List<String> physicians) {
        boolean retBool = false;
        if ( (physician != null && physician != '') && physician != 'Any' ) {
            integer iCnt = physicians.Size();
            for (string s: physicians) {
                system.debug('ValidatePhysicians: physician='+physician+';s='+s);
                if (physician.trim() == s.trim()) {
                    retBool = true;
	                system.debug('found a match - retBool='+retBool);
                    break;
                }
            }
        }    
        else if (physician == 'Any') {
            retBool = true;
        } else {
			retBool = false;            
        }
       	system.debug('ValidatePhysicians retBool='+retBool);
        return retBool;
    }
    
    private static void UpdateAutoAlertEmailSent (Id CaseId, List<String> Update_Email) {
        //post email sent, update the "...Email_Sent" field
        //Update_Email has the fields that need the update
        Case c = [Select Id, Auto_Alert_Imaging_Email_Sent__c, Auto_Alert_records_Email_Sent__c, Auto_Alert_pathology_Email_Sent__c From Case Where Id = :CaseId];
        Datetime dt = Datetime.now();
        for (String s: Update_Email) {
            switch on s.toLowerCase() {
                when 'imaging' {
                    c.Auto_Alert_Imaging_Email_Sent__c = dt;
                }
                when 'records' {
                    c.Auto_Alert_records_Email_Sent__c = dt;
                }
                when 'pathology' {
                    c.Auto_Alert_pathology_Email_Sent__c = dt;
                }
            }
        }
        try {
            update c;
        } catch (exception e) {
            system.debug('UpdateAutoAlertEmailSent Exception: ' + e.getMessage());
        }
    }
    
}