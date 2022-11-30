({
    /*
     * This init function allows the Parent Component to pass in an id to prepopulate a the lookup field
     */ 
    init : function(component, event, helper) {
        if (component.get('v.mSelectedRecord') != null) {
            if (component.get('v.mRecordsList').length == 0) {
                helper.getPrimaryFieldClient(component, event, helper);
            }            
        }     
    },
    
    /*
     * This method handles the focus event fired by the lookup field's search textbox
     * It opens the searchRes div
     */ 
    onSearchFocus : function(component, event, helper) {
        var searchResults = component.find("searchRes");
        helper.openElement(searchResults);     
    },
    
    /*
     * This method handles the blur event fired by the lookup field's search textbox
     * It closes the searchRes div. It is delayed by 100 miliseconds in order to allow the user to click on their desired result
     */     
    onSearchBlur : function(component, event, helper) {
        var searchResults = component.find("searchRes");
        var timer= setTimeout(
            $A.getCallback(function() {
                helper.closeElement(searchResults);
                if (component.get('v.mRequired')) {
                    if (component.get('v.mSelectedRecord') == null) {
                        helper.addError(component, searchResults, 'Complete this field');
                    }
                    else {
                        helper.removeError(component, searchResults);
                    }                    
                }
            }), 250
        );
        
    },
    
    /*
     * This method handles the keyup event on the lookup field's search textbox.
     * If the searchString is not empty, then it sets up a callback that will fire in 500 miliseconds. 
     * The callback calls a function that will query the serverside controller
     * If the keyup event is fired again before 500 miliseconds pass, the callback is cleared, and a callback is set for 500 miliseconds.
     * This prevents querying the serverside controller everytime the keyup event is fired
     */ 
    onSearchKeyUp : function(component, event, helper) {
        var timer = component.get('v.mTimer');
        var searchString = component.get('v.mSearchString');
        
        clearTimeout(timer);
        if (searchString) {
            var timer = setTimeout(
                $A.getCallback(function() {
                    helper.searchHelper(component, event, searchString);
                }), 500
            );
            component.set('v.mTimer', timer);
        }
    },
    
    /*
	 * This method is fired when the user clicks the "x" on the selected record. 
	 * It clears clears the values of mSelectedRecord, mSearchString, and mRecordsList
	 */ 
    onRemoveBtnClick : function(component,event,helper){
        
        var pillTarget = component.find("lookupPill");
        var lookUpTarget = component.find("lookupField"); 
        
        helper.hideElement(pillTarget);        
        helper.showElement(lookUpTarget);
        
        component.set("v.mSearchString",null);
        component.set("v.mRecordsList", null );
        component.set("v.mSelectedRecord", null );
        
    },
    
    /*
  	 * This method handles the COH_UTIL_SelectedRecordEvent that is fired when a user clicks on a LookupFieldResult item
  	 * It sets the value of mSelectedRecord
  	 */ 
    handleLookupFieldChange : function(component, event, helper) {
        var selectedAccountGetFromEvent = event.getParam("lookupFieldResult");
        var lookupPill = component.find("lookupPill");
        var searchRes = component.find("searchRes");
        var lookupField = component.find("lookupField");        
        
        component.set("v.mSelectedRecord" , selectedAccountGetFromEvent.id);
        component.set("v.mSelectedRecordPrimaryField", selectedAccountGetFromEvent.primaryField);
        helper.showElement(lookupPill);
        helper.closeElement(searchRes);
        helper.hideElement(lookupField); 
    },
    
    validateFields: function(component, event, helper) {
        var isValidInput = true;
        var searchResults = component.find('searchRes');
        var required = component.get('v.mRequired');
        
        if (required && !component.get('v.mSelectedRecord')) {
            helper.addError(component, searchResults, 'Complete this field');
            isValidInput = false;
        }
        
        return isValidInput;
    },       
    
    /*
     * 
     */ 
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
    
    /*
     * 
     */ 
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    }
})