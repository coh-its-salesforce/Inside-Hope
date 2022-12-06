({
    doInit : function(component, event, helper) {
        var action = component.get("c.getacc");
        action.setParams({
            accId: component.get("v.recordId")
        });
        var acc = {};
        action.setCallback(this, function(a) {
            if(a.getReturnValue() != null){
                acc = a.getReturnValue();
                component.set("v.accRec",acc);
            }            
        });
        $A.enqueueAction(action);
    },
    
    getInput : function(cmp, evt) {
        var acc = cmp.get("v.accRec");
        var RC = '';var RSL='';var RSRO='';var RROS='';var CCRM='';var CCTM='';var CCNM='';var CRCL=''; var CRL='';var OCO='';var DST='';var LA='';var CEM='';var CES='';var STB='';var SSB='';var SES='';var SEM='';var SRS='';var SCS ='';var RES=''; 
        CES="City of Hope PHI Request Form";
      //  DST="0B169320-40FC-419B-9B69-46840DA933D3"; 
        DST="9a9f78c3-e57a-43c5-9cc4-93cf9a3cad2a";
        OCO = 'Send'; 
        CCRM='Role1~Patient'; 
        CRL='Email~'+acc.PersonEmail+';LastName~'+acc.LastName+';FirstName~'+acc.FirstName+';Role~Role1;RoutingOrder~1'; 
        var vfEvent = $A.get("e.force:navigateToURL");
        vfEvent.setParams({
             "url": "/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID="+acc.COH_Account_ID__c+"&RC="+RC+"&RSL="+RSL+"&RSRO="+RSRO+"&RROS="+RROS+"&CCRM="+CCRM+"&CCTM="+CCTM+"&CRCL="+CRCL+"&CRL="+CRL+"&OCO="+OCO+"&DST="+DST+"&CCNM="+CCNM+"&LA="+LA+"&CEM="+CEM+"&CES="+CES+"&SRS="+SRS+"&STB="+STB+"&SSB="+SSB+"&SES="+SES+"&SEM="+SEM+"&SRS="+SRS+"&SCS="+SCS+"&RES="+RES
        });
        vfEvent.fire();
    }
});