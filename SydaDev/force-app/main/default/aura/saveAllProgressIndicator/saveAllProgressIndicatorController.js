({
    doInit: function (component) {
        component.set('v.showProgressBar',true)
    },
    
    indicatorCalled : function (component, event, helper) {
        var stepIndex = event.getParam('index');
        console.log('stepIndex',stepIndex);
        console.log('Status',component.get('v.caseStatus'))
        if(stepIndex == 0){
            component.set('v.caseStatusNew','New')
        }
        if(stepIndex == 1){
            component.set('v.caseStatusNew','Inquiry')
        }
        if(stepIndex == 2){
            component.set('v.caseStatusNew','Registered')
        }
        if(stepIndex == 3){
            component.set('v.caseStatusNew','Nursing Review')
        }
        if(stepIndex == 4){
            component.set('v.caseStatusNew','Records Procurement')
        }
        if(stepIndex == 5){
            component.set('v.caseStatusNew','Closed')
        }
        
        if(component.get('v.caseStatusNew') == component.get('v.caseStatus')){
            component.set('v.showSaveAll',true);
        }else{
            component.set('v.showSaveAll',false);
        }
        console.log('caseStatusNew',component.get('v.caseStatusNew'))
    },
    
    closeModel: function (component) {
        component.set('v.isModalOpen',false);
    },
    
    handleOnLoad: function (component,event) {
        var recUi = event.getParam("recordUi");
        console.log(recUi.record.fields["Status"].value)
    },
    
    handleOnSubmit: function (component) {
        component.set('v.server',true)
    },
    handleOnSuccess: function (component) {
        component.set('v.server',false);
        component.set('v.caseStatus',component.get('v.caseStatusNew'));
        $A.get('e.force:refreshView').fire();
        component.find('recordLoader').reloadRecord(true);
        setTimeout(function() {
            window.open("/"+component.get('v.recordId'), "_self");
        }, 2000);
        
    },
    handleError:function (component) {
        
        component.set('v.server',false)
    },
    
    saveAll: function (component) {
         component.set('v.spinner',true);
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.publishEvent");
        action.setParams({ recordId : component.get("v.recordId") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var timer = component.get('v.timer');
                clearTimeout(timer);
                
                var timer = setTimeout(function(){
                    component.set('v.spinner',false);
                    clearTimeout(timer);
                    component.set('v.timer', null);
                }, 20000);
                
                component.set('v.timer', timer);
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
    },
    
    countSuccess: function (component,event,helper) {
        var count = component.get('v.successCount');
        var initcount = component.get('v.initCount');
        count = count +1;
        component.set('v.successCount',count);
        console.log('count ',count);
        if(count === initcount){
            component.set('v.spinner',false);
        }
        
        var message = event.getParam("message"); 
        var formName = event.getParam("formName"); 
      //  console.log('count1** ',message);
        console.log('count2** ',formName);
         
        
    },
    
     initCount: function (component,event,helper) {
        var count = component.get('v.initCount');
        count = count +1;
        component.set('v.initCount',count);
        
    },
    
    saveAllServer: function (component,event,helper) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        helper.changeStatus(component,event,helper);
        /*component.set('v.spinner',true);
        var action = component.get("c.ValidateForms");
        action.setParams({ caseRecord : component.get("v.recordId"),
                          saveAll : 'saveAll'});
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.spinner',false);
            if (state === "SUCCESS") {
                console.log('response',JSON.parse(response.getReturnValue()));
                var mapData = JSON.parse(response.getReturnValue());
                if(mapData.isError == true){
                    helper.showErrorToast(component,event,"Forms have errors, please review Patient Checklist");
                }else{
                    helper.changeStatus(component,event,helper);
                    helper.showSuccessToast(component);
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);*/
        
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            component.set('v.caseStatus',component.get('v.caseRecord').Status)
            //component.set('v.caseStatusNew',component.get('v.caseRecord').Status)
            component.set('v.showProgressBar',true);
            console.log("Record is loaded successfully.",JSON.parse(JSON.stringify(component.get('v.caseRecord'))) );
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
});