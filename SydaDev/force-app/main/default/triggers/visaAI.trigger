trigger visaAI on Visa__c (After Insert){
    VisaHelper.shareVisaRecord(trigger.new[0]);
 }