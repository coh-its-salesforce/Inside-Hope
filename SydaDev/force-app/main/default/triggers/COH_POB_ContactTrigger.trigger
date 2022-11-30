/*
 * Trigger for the Contact object. 
 * Only handles functionality necessary for the Community/Duarte Physician Onboarding/Offboarding apps.
 * Tim Hughes
 */ 
trigger COH_POB_ContactTrigger on Contact (before update) {
    List<Contact> updatedContact = new List<Contact>();
    
    if (Trigger.isUpdate && Trigger.isBefore) {
        for (Contact currentContact : Trigger.New) {
            updatedContact.add(currentContact);
        }
        COH_POB_ContactTriggerHelper.massUpdateHandler(updatedContact);
    }
}