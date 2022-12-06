({

    /*
     * Gets the default values for the SObject from the Custom Setting COH_UTIL_ShareRecord_Defaults
     */
    getDefaultSharingValuesClient : function(component, helper) {
        var action = component.get('c.getDefaultValues');
        var recordId = component.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var defaultValues = response.getReturnValue();
                if (defaultValues) {
                    if (defaultValues.Sharing_Access_Level__c) {
                        component.set('v.mSharingAccessLevel', defaultValues.Sharing_Access_Level__c);
                    }
                    if (defaultValues.Component_Header__c) {
                        component.set('v.mComponentHeader', defaultValues.Component_Header__c);
                    }
                    if (defaultValues.Email_Template_Id__c) {
                        component.set('v.mEmailTemplateId', defaultValues.Email_Template_Id__c);
                    }
                    component.set('v.mLoading', false);
                }
            }
            else {
                if(state == 'ERROR') {
                    var errors = response.getError();
                    helper.handleError(component,'Error','There was an error initializing the component: \n' + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * Create the new [SObject]__Share record
     * Calls the COH_UTIL_ShareRecordController.shareRecordServer method
     */
    saveShareRecordClient: function(component, helper) {
        var action = component.get('c.shareRecordServer');
        var recordId = component.get('v.recordId');
        var userId = component.get('v.mUserId');
        var sharingAccessLevel = component.get('v.mSharingAccessLevel');
        var emailTemplateId = component.get('v.mEmailTemplateId');
        var emailUser = component.get('v.mEmailUser');
        action.setParams({recordId:recordId, userId:userId, sharingAccessLevel:sharingAccessLevel, emailUser:emailUser, emailTemplateId:emailTemplateId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state=='SUCCESS'){
                helper.resetFields(component, helper);
                helper.showAlert(component, 'The record was successfully shared with the selected User');
            }
            else {
                if (state == 'ERROR') {
                    var errors = response.getError();
                    helper.handleError(component,'Error','There was an error sharing the record: \n' + errors[0].message);
                    component.set('v.mDisableShareBtn', false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    /*
     * This method displays the errors returned by the server side controller.
     */
    handleError: function(component,errorHeader,errorMessage) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": 'Error',
            "message": errorMessage,
        });
    },

    showAlert : function(component, message) {
        component.set('v.mShowNotification', true);
        component.set('v.mNotificationMessage', message);

        var timer = setTimeout(
            $A.getCallback(function() {
                component.set('v.mShowNotification', false);
            }), 5000
        );
    },

    /*
     * This method resets the values of the fields on the component to the initial states.
     */
    resetFields : function(component, helper) {
        component.set('v.mLoading', true);
        component.set('v.mUserId', null);
        component.set('v.mEmailUser', false);
        component.set('v.mDisableShareBtn', false);
        component.set('v.mLoading', false);
    },    
})