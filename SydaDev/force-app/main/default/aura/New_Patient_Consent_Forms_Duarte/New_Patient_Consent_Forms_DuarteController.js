({
    /*
     * Initialize the Lightning component.
     * 
     * @param component		Component.
     * @param event			Event.
     * @param helper		Helper.
     * 
     */
    doInit : function(component, event, helper) {
        var action = component.get("c.getcase");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        var cas = {};
        action.setCallback(this, function(a) {
            if(a.getReturnValue() != null){
                cas = a.getReturnValue();
                component.set("v.caseRec",cas);
            }            
        });
        $A.enqueueAction(action);
    },
    
    /*
     * Send the PHI Release document.
     * 
     * @param component		Component.
     * @param event			Event.
     * 
     */
    sendGeneralConsent: function(component, event) {
        var action = component.get('c.getcase');
        var caseRecID = component.get('v.recordId');
        action.setParams({caseId: caseRecID});

        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === 'SUCCESS') {
                var cas = response.getReturnValue();
                if (cas != null) {
                    component.set("v.caseRec",cas);
                    var RC = '';var RSL='';var RSRO='';var RROS='';var CCRM='';var CCTM='';var CCNM='';var CRCL=''; var CRL='';var OCO='';var DST='';var LA='';var CEM='';var CES='';var STB='';var SSB='';var SES='';var SEM='';var SRS='';var SCS ='';var RES=''; 
                    CES="City of Hope General Consent Forms For Signature"; 
                    DST="8781ee05-0d11-4ce1-83bd-ad28bda50830"; 
                    OCO = 'Send'; 
                    CCRM='Role1~Patient'; 
                    CRL='Email~'+cas.Contact_Email__c+';FirstName~'+cas.Contact.FirstName +';LastName~'+cas.Contact.LastName +';Role~Role1;RoutingOrder~1'; 
                    var vfEvent = $A.get("e.force:navigateToURL");
                    vfEvent.setParams({
                        "url": "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+cas.Id+"&RC="+RC+"&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+"&CRL="+CRL+"&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+CES+"&SRS="+SRS+"&STB="+STB+"&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+SCS+"&RES="+RES
                    });
                    vfEvent.fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                    helper.showToast("Error: General Consent Outpatient", "error", "Case record could not be retrieved. It may have been deleted by another user. Case ID: " + caseRecID);                
                }
            } else if (responseState === 'ERROR') {
                var errors = response.getError();
                var message = 'Unknown error encountered';  // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast("Error: General Consent Outpatient not sent", "error", "An error occurred while attempting to send the PHI release: " + message);                
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * Method to call the e.force:showToast event
     * @param title			Message title.
     * @param type			Message type.
     * @param message		Message contents.
     *
     */ 
    showToast : function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    }
                           
});