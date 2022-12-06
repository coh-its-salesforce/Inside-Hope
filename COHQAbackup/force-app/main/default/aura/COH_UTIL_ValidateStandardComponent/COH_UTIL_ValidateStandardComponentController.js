({
    validateFields : function(component, event, helper) {
        var params = event.getParam('arguments');
        var isValidInput = true;

        if (params) {
            var fieldsToValidate = params.fieldsToValidate;
            if (fieldsToValidate) {
                if ($A.util.isArray(fieldsToValidate)) {
                    for (var i = 0; i < fieldsToValidate.length; i++) {	
                        isValidInput = helper.validateField(fieldsToValidate[i]) && isValidInput;
                    }
                }
                else {
                    isValidInput = helper.validateField(fieldsToValidate);
                }                
            }
        }
        return isValidInput;
    }
})