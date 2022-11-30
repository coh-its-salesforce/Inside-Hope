({
    validateField : function (fieldToValidate) {
        var isValidInput = true;
        if (fieldToValidate.isInstanceOf('lightning:input') || fieldToValidate.isInstanceOf('lightning:textarea') || fieldToValidate.isInstanceOf('lightning:select')) {
            isValidInput = this.validateStandardInput(fieldToValidate);
        }
        else if (fieldToValidate.isInstanceOf('lightning:checkboxGroup')) {
            isValidInput = this.validateCheckboxGroup(fieldToValidate);
        }
        return isValidInput;
    },
   
    validateStandardInput : function (field) {
		field.showHelpMessageIfInvalid();
        return field.get('v.validity').valid;;
	},
    
    validateCheckboxGroup : function (field) {
        if (!field.checkValidity()) {
            $A.util.addClass(field, 'slds-has-error');
        }
        return field.checkValidity();
    }
})