({
	loadData : function(component, event, helper) {
		var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getSummaryRecords"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMRecs",ITProjectIntakeInfo);
                var UId1=component.get("v.ITPMRecs.BMC_Change_Request__c");
                var UName=component.get("v.ITPMRecs.CR_Name__c");
                var alink1="/apex/BMCServiceDesk__ConsoleRedirect?formulaFieldName=ChangeRequestLaunchConsole&recordName="+UName+"&recordId="+UId1+"&isdtp=vwuiTheme=Theme3&formLayoutId=";
                var alink2="/apex/BMCServiceDesk__ConsoleRedirect?formulaFieldName=ChangeRequestLaunchConsole&amp;recordName=NEW&amp;recordId=NEW&amp;isdtp=vw&amp;uiTheme=Theme4d&amp;formLayoutId=";
                component.set("v.link1",alink1);
                component.set("v.link2",alink2);                
            }
            else if(Res.getState() == "ERROR"){
            }
        });
        $A.enqueueAction(ITPMRecAction);
	}
})