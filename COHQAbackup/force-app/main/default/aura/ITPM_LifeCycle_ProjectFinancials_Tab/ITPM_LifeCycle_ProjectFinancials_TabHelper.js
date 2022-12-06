({
	loadData : function(component, helper) {
		var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getSummaryRecords"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                
                console.log('Year 1===>'+JSON.stringify(ITProjectIntakeInfo.ITS_Intake_Request__r.Revised_Capex_Budget_Year_1__c));
                console.log('Year 2===>'+JSON.stringify(ITProjectIntakeInfo.ITS_Intake_Request__r.Revised_Capex_Budget_Yr_2__c));
                console.log('Year 3===>'+JSON.stringify(ITProjectIntakeInfo.ITS_Intake_Request__r.Revised_Capex_Budget_Yr_3__c));
                var activeSec = component.get("v.activeSections");
                if(parseFloat(JSON.stringify(ITProjectIntakeInfo.ITS_Intake_Request__r.Revised_Capex_Budget_Yr_2__c))>0){
                    activeSec.push('YEAR 2 BUDGET DETAIL');
                }
                if(parseFloat(JSON.stringify(ITProjectIntakeInfo.ITS_Intake_Request__r.Revised_Capex_Budget_Yr_3__c))>0){
                    activeSec.push('YEAR 3 BUDGET DETAIL');
                }
                component.set("v.activeSections",activeSec);
                component.set("v.ITPMRecs",ITProjectIntakeInfo);
            }
        });
        $A.enqueueAction(ITPMRecAction);
	},
    displayButton: function(cmp,helper){
        var action = cmp.get("c.getDetails"); 
        action.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var rdata=Res.getReturnValue();
                cmp.set('v.displayButton',rdata);
            }
        });
        $A.enqueueAction(action);
    }
})