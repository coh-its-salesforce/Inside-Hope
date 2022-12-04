/*
 * This is the APEX Controller for the COH_UTIL_ShareRecord Component Bundle.
 * 
 * Tim Hughes
 */ 
public class COH_UTIL_ShareRecordController {
    PRIVATE STATIC FINAL SET<STRING> CUSTOM_EMAIL_OBJECTS = NEW SET<STRING> {'COH_CEAForm__c'};

    /*
     * Gets the default values for the object type from the COH_UTIL_ShareRecord_DefaultValues__c custom setting
     * Uses a supplied Salesforce record id to determine which default values to get
     * 
     * @param Id recordId						The Salesforce record id
     * 
     * @return									1. If the object has a valid COH_UTIL_ShareRecord_DefaultValues__c custom setting, then the custom setting record is returned
     * 											2. If the object does not have a valid COH_UTIL_ShareRecord_DefaultValues__c custom setting, then null is returned. The component is responsible for handling default values
     * 											3. If recordId is null an AuraHandledException is thrown
     */ 
    @AuraEnabled
    public static COH_UTIL_ShareRecord_DefaultValues__c getDefaultValues(Id recordId) {
        if (recordId != null) {
            String objectAPIName = recordId.getSobjectType().getDescribe().getName();
            COH_UTIL_ShareRecord_DefaultValues__c defaultValues = COH_UTIL_ShareRecord_DefaultValues__c.getValues(objectAPIName);
            if (defaultValues != null) {
				return defaultValues;
            }
            else {
                return null;
            }
        }
        else {
            throw new AuraHandledException('Invalid Record Id');
        }
    }

    /*
     * Method called from COH_UTIL_ShareRecord component bundle
     * Uses a supplied Salesforce record id and Schema functions to determine the type of sharing object to create a record for
     * NOTE: Standard objects have differernt share records than custom objects. This method currently only supports custom objects
     * 
     * @Param Id recordId						The Salesforce record id to create a sharing record for. (ParentId)
     * @Param Id userId							The id of the user to share the record with. (UserOrGroupId)
     * @Param String sharingAccessLevel			The level of access that the user should have to the record. (AccessLevel)
     */ 
    @AuraEnabled
    public static void shareRecordServer(Id recordId, Id userId, String sharingAccessLevel, Boolean emailUser) {
        Schema.DescribeSObjectResult objectResult;

        if (recordId == null) {
            throw new AuraHandledException('Invalid Record Id');
        }
        if (userId == null) {
            throw new AuraHandledException('Invalid User Id');
        }
        if (!(COHUtil.isValidStr(sharingAccessLevel))) {
            throw new AuraHandledException('Invalid Access Level');
        }

        objectResult = recordId.getSObjectType().getDescribe();
        if (objectResult.isCustom()) {
            shareCustomObjectRecord(objectResult, recordId, userId, sharingAccessLevel);
            if (emailUser) {
                sendEmailMessage(recordId, userId);
            }
        }
        else {
            throw new AuraHandledException('This Sobject is not supported at this time. Please contact your Salesforce administrator');
        }
    }

    /*
     * This method creates a __Share record for a custom objet. 
     */
    private static Sobject shareCustomObjectRecord(Schema.DescribeSObjectResult objectResult, Id recordId, Id userId, String sharingAccessLevel) {
        Schema.SObjectType objectType;
        SObject newSharingRecord;
        String objectAPIName, shareObjectName;

        shareObjectName = objectResult.getName().replace('__c', '__Share');
        objectType = Schema.getGlobalDescribe().get(shareObjectName);
        //Need to add try catch - There is no [SObject]__Share if the SObject is not set to private
        newSharingRecord = objectType.newSObject();
        newSharingRecord.put('AccessLevel', sharingAccessLevel);
        newSharingRecord.put('ParentId', recordId);
        newSharingRecord.put('UserOrGroupId', userId);
        
        try {
            insert newSharingRecord;
        }
        catch (Exception e) {
            List<sObject> sharingRecords = Database.query('SELECT UserOrGroupId, AccessLevel FROM ' + shareObjectName + ' WHERE ParentId=\'' + recordId + '\'');
            if (sharingRecords != null) {
                for (sObject i : sharingRecords) {
                    if (i.get('UserOrGroupId') == userId && i.get('AccessLevel') == 'All') {
                        throw new AuraHandledException('The selected user already has enhanced permission to view this record');
                    }
                }
            }
            throw new AuraHandledException(e.getMessage());
        }
        return newSharingRecord;
    }

    /*
     *
     */
    private static void sendEmailMessage(Id recordId, Id recipientId) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        emailsToSend.add(createCEAEmail(recordId, recipientId));
        Messaging.sendEmail(emailsToSend);
    }

    /*
     * This method creates a email customized for sharing a COH_CEAForm__c record
     */
    private static Messaging.SingleEmailMessage createCEAEmail(Id recordId, Id recipientId) {
        COH_CEAForm__c CEAForm = [SELECT id, Name FROM COH_CEAForm__c WHERE id=:recordId];
        User sharedWithUser = [SELECT id, Name, Email FROM User WHERE id=:recipientId];
        User sharingUser = [SELECT id, Name FROM User WHERE id=:UserInfo.getUserId()];
        COH_Config_Setting__c environmentDomainCustomSetting = COH_Config_Setting__c.getValues('Environment Domain');
        String environmentDomain;
        if (environmentDomainCustomSetting != null) {
            environmentDomain = environmentDomainCustomSetting.Value__c;
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailSubject = sharingUser.Name + ' has shared a CEA Form with you';
        List<String> emailToAddresses = new List<String> {sharedWithUser.Email};
        String emailBody = 
            'Hello ' + sharedWithUser.Name + ',</br>' + 
            'CEA <b>' + CEAForm.Name + '</b> has been shared with you.</br></br>' + 
            'Please <a href="' + environmentDomain + '/' + CEAForm.Id + '">click here</a> to view the form.';
        email.Subject = emailSubject;
        email.setToAddresses(emailToAddresses);
        email.setHtmlBody(emailBody);
        
        System.debug('Domain: ' + environmentDomain);

        return email;
    }
}