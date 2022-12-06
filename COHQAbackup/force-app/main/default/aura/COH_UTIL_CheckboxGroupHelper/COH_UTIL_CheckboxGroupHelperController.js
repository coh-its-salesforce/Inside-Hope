({
	/*
	 * This method changes a javascript array into a semi-colon delimited list.
	 * It is used in order to change the values from CheckboxGroups into a format that a Multiple select picklist will accept.
	 */     
    jsonArrayToMultipleSelectPicklist : function(component, event) {
        var params = event.getParam('arguments');
        var valuesString = '';
        
        if (params) {
            var valuesArray = params.valuesArray;
            if (valuesArray) {
                
                for (var i = 0; i <valuesArray.length; i++) {
                    valuesString += valuesArray[i] + ';';
                }
            }
        }
        return valuesString;
    },
    
    /*
     * This method changes the string form a multiple select picklist to a JSON array
     */
    multipleSelectPicklistToJSONArray: function (component, event) {
        var params = event.getParam('arguments');
        var returnValue = '';
        
        if (params) {
        	var multipleSelectPicklist = params.multipleSelectPicklist;
            if (multipleSelectPicklist) {
                returnValue = multipleSelectPicklist.split(';');
            }
        }
		return returnValue;
    },
    
    /*
     * This method creates a Map of all the possible departments that his project can affect. 
     * The key is the Department name with white spaces removed(so it can be accessed in the component) the value is a boolean value
     * The boolean value is determined by the COH_UIR_SHR_ImpactedDepatmentDetails__c field
     * Used to determine which inputs the child sections for Resource Involvement and Impact Rating need to show
     */ 
    createJSONStringFromGroupboxValue: function(component, event) {
        var params = event.getParam('arguments');
        var jsonString = '{';

        if (params) {
            var valuesArray = params.valuesArray;
        }
        for (var i = 0; i < valuesArray.length; i++) {
            jsonString += '"' + valuesArray[i].replace(/[^\w]/gi,'') + '":"true",';
        }
        if(jsonString.length > 1){
        	jsonString = jsonString.slice(0,jsonString.length-1);
        }        
        jsonString += '}';

        return JSON.parse(jsonString);
    }    
})