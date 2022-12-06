({
    searchHelper : function(component, event, searchString) {
        var action = component.get("c.fetchLookUpValues");
        
        action.setParams({
            'searchString': searchString,
            'SObjectAPIName' : component.get("v.mSObjectAPIName"),
            'primaryFieldAPIName' : component.get('v.mPrimaryFieldAPIName'),
            'secondaryFieldAPIName' : component.get('v.mSecondaryFieldAPIName'),
            'numberOfRecordsToShow' : component.get('v.mNumberOfRecordsToShow'),
            'additionalSearchConditions' : component.get('v.mAdditionalSearchConditions'),
            'additionalSelectFields' : component.get('v.mAdditionalSelectFields')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = JSON.parse(response.getReturnValue());
                
                if (storeResponse.length == 0) {
                    component.set("v.,Message", 'No Result Found...');
                } 
                else {
                    component.set("v.mMessage", '');
                }
                component.set("v.mRecordsList", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    
    getPrimaryFieldClient : function(component, event, helper) {
        var action = component.get('c.getPrimaryFieldServer');
        
        action.setParams({
            'recordId' : component.get('v.mSelectedRecord'),
            'primaryFieldAPIName' : component.get('v.mPrimaryFieldAPIName'),
            'SObjectAPIName' : component.get('v.mSObjectAPIName')
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.mSelectedRecordPrimaryField", response.getReturnValue());
                var lookupPill = component.find("lookupPill");
                var searchRes = component.find("searchRes");
                var lookupField = component.find("lookupField");                      
                helper.showElement(lookupPill);
                helper.closeElement(searchRes);
                helper.hideElement(lookupField); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    openElement: function(elementTOpen) {
        $A.util.addClass(elementTOpen, 'slds-is-open');
        $A.util.removeClass(elementTOpen, 'slds-is-close');  
    },
    
    closeElement: function(elementToClose) {
        $A.util.addClass(elementToClose, 'slds-is-close');
        $A.util.removeClass(elementToClose, 'slds-is-open');    
    },
    
    showElement: function(elementToShow) {
        $A.util.addClass(elementToShow, 'slds-show');
        $A.util.removeClass(elementToShow, 'slds-hide');
    },
    
    hideElement: function(elementToHide) {
        $A.util.addClass(elementToHide, 'slds-hide');
        $A.util.removeClass(elementToHide, 'slds-show'); 
    },
    
    addError : function(component, elementToAddError, errorMessage) {
    	$A.util.addClass(elementToAddError, 'slds-has-error');
        component.set('v.mErrorMessage', errorMessage);
        component.set('v.mHasError', 'true');
        
    },
    
    removeError : function(component, elementToRemoveError) {
        component.set('v.mHasError', 'false');
        component.set('v.ErrorMessage', '')
        $A.util.removeClass(elementToRemoveError, 'slds-has-error');
    }
    
})