({
	getITSAssetRecordClient : function(component, helper) {
		var action = component.get('c.getITSAssetRecordServer');
		var recordId = component.get('v.recordId');
        
		action.setParams({recordId:recordId});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == 'SUCCESS') {
				var returnValue = response.getReturnValue();
				var iframeSource = component.get('v.mURL') + '?e=' + returnValue.Employee__r.EmployeeNumber; 

				component.set('v.mURL', iframeSource);
				component.set('v.mLoading', false);
			}
		});
		$A.enqueueAction(action);
	}
})