({
	getFoundationCaseClient : function(component, helper) {
        var action = component.get("c.getFoundationCaseServer");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var returnValue = response.getReturnValue();
                helper.sendGeneralConsent(returnValue);
            }
            else {
                var errors = response.getError();
                var message = 'Unknown Error. Please contact your Salesforce administrator'
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                helper.showToast(message,'Error Sending General Consent Form', 'error');
            }
        });
        $A.enqueueAction(action);		
	},

   sendGeneralConsent : function(caseRecord) {
        var RC = '';var RSL='';var RSRO='';var RROS='';var CCRM='';var CCTM='';var CCNM='';var CRCL=''; var CRL='';var OCO='';var DST='';var LA='';var CEM='';var CES='';var STB='';var SSB='';var SES='';var SEM='';var SRS='';var SCS ='';var RES=''; 
        //  CES="City of Hope Foundation General Consent For Treatment";
       // DST="e411272e-b454-4e31-9bf9-252f59d79d35"; 
        CES="City of Hope Foundation General Consent For Treatment";
        DST="e411272e-b454-4e31-9bf9-252f59d79d35";     
        OCO = 'Send'; 
        CCRM='Role1~Patient'; 
        CRL='Email~'+caseRecord.Account.PersonEmail+';LastName~'+caseRecord.Account.LastName+';FirstName~'+caseRecord.Account.FirstName+';Role~Role1;RoutingOrder~1'; 
        var vfEvent = $A.get("e.force:navigateToURL");
        vfEvent.setParams({
             "url": "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+caseRecord.Id+"&RC="+RC+"&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+"&CRL="+CRL+"&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+CES+"&SRS="+SRS+"&STB="+STB+"&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+SCS+"&RES="+RES
        });
        vfEvent.fire();
    },
    
    showToast : function(message, title, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
			"title": title,
            "type": type
        });
        toastEvent.fire();
    }    
})