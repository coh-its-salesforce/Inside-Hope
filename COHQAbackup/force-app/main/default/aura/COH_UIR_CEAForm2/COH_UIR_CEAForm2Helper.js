({
    getRecordClient : function(component, helper) {
        var action = component.get("c.getRecordServer");
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        action.setParams({recordId : component.get("v.recordId")});
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === 'SUCCESS') { 
            	var ceaForm = result.getReturnValue();
                component.set("v.mCEAForm", ceaForm);
                component.set('v.mCheckboxGroupValues.COH_CEA_Funding__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_Funding__c));
                component.set('v.mCheckboxGroupValues.COH_CEA_ProjectCategory__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_ProjectCategory__c));
                component.set('v.mCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_OtherClassificationUpgrades__c));
                component.set('v.mCheckboxGroupValues.COH_CEA_ProjectClassification__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_ProjectClassification__c));
                component.set('v.mCheckboxGroupValues.COH_CEA_DispositionReason__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_DispositionReason__c));
                component.set('v.mCheckboxGroupValues.COH_CEA_RequestType__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(ceaForm.COH_CEA_RequestType__c));
                
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_Funding__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_Funding__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_ProjectCategory__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectCategory__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_ProjectClassification__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectClassification__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_DispositionReason__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_DispositionReason__c')));
                component.set('v.mSelectedCheckboxGroupValues.COH_CEA_RequestType__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_RequestType__c')));

                helper.updateTotalUnitCost(component);
                helper.updateTotalInitialCost(component);
                helper.updateTotalOpexCost(component);
            }
            else if (state === 'ERROR') {
                console.log('Error');
            }
            component.set('v.mRecordLoaded', true);
        });
        $A.enqueueAction(action);
    },    
    
    getPicklistsClient: function(component, helper) {
        var action = component.get("c.getPicklistsServer");
        action.setParams({ 'formSection' : 'CEA Form' });
        
        action.setCallback(this, function(response) {
            component.set("v.mPicklists", JSON.parse(response.getReturnValue()));
            helper.getRecordClient(component, helper)
        });
        $A.enqueueAction(action);
    },
    
    saveRequestClient: function(component, event, helper) {
        // First have to change checkboxgroups into comma delimited groups
        helper.saveCheckboxGroups(component);
		var ceaForm =  component.get('v.mCEAForm');
        var clickedBtn = event.getSource();
        var action = component.get("c.saveRecordServer");
        
        action.setParams({ recordToSave : ceaForm });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success\n",
                    "message": "Request saved successfully",
                    "type": "success"
                });
                toastEvent.fire();
                clickedBtn.set('v.disabled', false);
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = result.getError();
                helper.handleError(errors[0].message);
                clickedBtn.set('v.disabled', false);
            }
        });
        $A.enqueueAction(action);        
    },    
    
    setupCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');        
        component.set('v.mCheckboxGroupValues.COH_CEA_Funding__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_Funding__c')));
        component.set('v.mCheckboxGroupValues.COH_CEA_ProjectCategory__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_ProjectCategory__c')));
        component.set('v.mCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_OtherClassificationUpgrades__c')));
        component.set('v.mCheckboxGroupValues.COH_CEA_ProjectClassification__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_ProjectClassification__c')));
        component.set('v.mCheckboxGroupValues.COH_CEA_DispositionReason__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_DispositionReason__c')));
        component.set('v.mCheckboxGroupValues.COH_CEA_RequestType__c', checkboxGroupHelper.multipleSelectPicklistToJSONArray(component.get('v.mCEAForm.COH_CEA_RequestType__c')));
        
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_Funding__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_Funding__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_ProjectCategory__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectCategory__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_ProjectClassification__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectClassification__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_DispositionReason__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_DispositionReason__c')));
        component.set('v.mSelectedCheckboxGroupValues.COH_CEA_RequestType__c', checkboxGroupHelper.createJSONStringFromGroupboxValue(component.get('v.mCheckboxGroupValues.COH_CEA_RequestType__c')));
    },
    
    saveCheckboxGroups : function(component) {
        var checkboxGroupHelper = component.find('checkboxGroupHelper');
        component.set('v.mCEAForm.COH_CEA_Funding__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_Funding__c')));
        component.set('v.mCEAForm.COH_CEA_ProjectCategory__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectCategory__c')));
        component.set('v.mCEAForm.COH_CEA_OtherClassificationUpgrades__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_OtherClassificationUpgrades__c')));
        component.set('v.mCEAForm.COH_CEA_ProjectClassification__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_ProjectClassification__c')));
        component.set('v.mCEAForm.COH_CEA_DispositionReason__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_DispositionReason__c')));
        component.set('v.mCEAForm.COH_CEA_RequestType__c', checkboxGroupHelper.jsonArrayToMultipleSelectPicklist(component.get('v.mCheckboxGroupValues.COH_CEA_RequestType__c')));
    },

    updateTotalUnitCost : function(component) {
        var unitCost = parseInt(component.get("v.mCEAForm.COH_CEA_UnitCost__c"));
        var quantity = parseInt(component.get("v.mCEAForm.COH_CEA_Quantity__c"));
        var totalCost;
        
        if (isNaN(unitCost) || unitCost == '') {
            unitCost = 0;
        }
        if (isNaN(quantity) || quantity == '') {
            quantity = 0;
        }        
        
        totalCost = unitCost * quantity;
        
        component.set("v.mTotalUnitCost", totalCost);
    },

    updateTotalInitialCost : function(component) {
        var freight = parseInt(component.get("v.mCEAForm.COH_CEA_Freight__c"));
        var salesTax = parseInt(component.get("v.mCEAForm.COH_CEA_SalesTax__c"));
        var installation = parseInt(component.get("v.mCEAForm.COH_CEA_Installation__c"));
        var deInstallation = parseInt(component.get("v.mCEAForm.COH_CEA_DeInstallation__c"));
        var other = parseInt(component.get("v.mCEAForm.COH_CEA_OtherCost__c"));
        var discounts = parseInt(component.get("v.mCEAForm.COH_CEA_Discounts__c"));
        var tradeIn = parseInt(component.get("v.mCEAForm.COH_CEA_DisposalTradeInValue__c"));
        var totalUnitCost = parseInt(component.get("v.mTotalUnitCost"));
        var totalCost;
        
        if (isNaN(freight) || freight == '') {
            freight = 0;
        }
        if (isNaN(salesTax) || salesTax == '') {
            salesTax = 0;
        }
        if (isNaN(installation) || installation == '') {
            installation = 0;
        }
        if (isNaN(deInstallation) || deInstallation == '') {
            deInstallation = 0;
        }
        if (isNaN(other) || other == '') {
            other = 0;
        }
        if (isNaN(discounts) || discounts == '') {
            discounts = 0;
        }
        if (isNaN(tradeIn) || tradeIn == '') {
            tradeIn = 0;
        }
        if (isNaN(totalUnitCost) || totalUnitCost == '') {
            totalUnitCost = 0;
        }        
        
        totalCost = (totalUnitCost + freight + salesTax + installation + deInstallation + other) - (discounts + tradeIn);
        
        component.set("v.mTotalInitialCost", totalCost);
    },

    updateTotalOpexCost : function(component) {
        var maintenanceContract = parseInt(component.get("v.mCEAForm.COH_CEA_MaintenanceContract__c"));
        var additionalSalaries = parseInt(component.get("v.mCEAForm.COH_CEA_AdditionalSalaries__c"));
        var additionalSupplies = parseInt(component.get("v.mCEAForm.COH_CEA_AdditionalSupplies__c"));
        var training = parseInt(component.get("v.mCEAForm.COH_CEA_TrainingCost__c"));
        var operatingSavings = parseInt(component.get("v.mCEAForm.COH_CEA_OperatingSavings__c"));
        var expectedRevenue = parseInt(component.get("v.mCEAForm.COH_CEA_ExpectedRevenue__c"));
        var expectedROI = parseInt(component.get("v.mCEAForm.COH_CEA_ExpectedROI__c"));        
        var totalOpexCost;
        
        if (isNaN(maintenanceContract) || maintenanceContract == '') {
            maintenanceContract = 0;
        }
        if (isNaN(additionalSalaries) || additionalSalaries == '') {
            additionalSalaries = 0;
        }
        if (isNaN(additionalSupplies) || additionalSupplies == '') {
            additionalSupplies = 0;
        }
        if (isNaN(training) || training == '') {
            training = 0;
        }        
        if (isNaN(operatingSavings) || operatingSavings == '') {
            operatingSavings = 0;
        }
        if (isNaN(expectedRevenue) || expectedRevenue == '') {
            expectedRevenue = 0;
        }
        if (isNaN(expectedROI) || expectedROI == '') {
            expectedROI = 0;
        }        
        
        totalOpexCost = (maintenanceContract + additionalSalaries + additionalSupplies + training) - (operatingSavings + expectedRevenue + expectedROI);
        
        component.set("v.mTotalOperatingExpenses", totalOpexCost);
    } 
})