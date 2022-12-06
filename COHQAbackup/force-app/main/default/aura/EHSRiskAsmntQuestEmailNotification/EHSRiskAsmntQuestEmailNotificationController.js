({
    doInit : function(component, event, helper) {
        var action = component.get("c.updateNotification");
        //Set method parameter of updateStudent() method, where "v.recordId" returns object record id of current screen.
        action.setParams({"recordId": component.get("v.recordId")});
        
        action.setCallback(this, function(response){
            //<response.getState()> return response status as SUCCESS/ERROR/INCOMPLETE etc.
            var state = response.getState();
            console.log("state="+state)
            //If response from server side is <SUCCESS>, then we will set the component attribute "studentObj".
            if (state === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Email!",
                    "type":"success",
                    "message": "Email Sent Successfully"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }else if (state === "INCOMPLETE") {
                //Offline message display logic.
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "OFFLINE!",
                    "message": "You are in offline."
                });
                toastEvent.fire();
            }else if (state === "ERROR") {
                //Error message display logic.
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR!",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }else {
                //Unknown message display logic.
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "UNKOWN!",
                    "message": "Unknown error."
                });
                toastEvent.fire();
            }
           $A.get("e.force:closeQuickAction").fire();
        });
        
        $A.enqueueAction(action);
        
       
    }
})