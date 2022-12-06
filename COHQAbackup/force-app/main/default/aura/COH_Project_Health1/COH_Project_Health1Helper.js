({
    loadCurrentUserProfile : function(component,event,helper) {
		 var ITPMRecAction = component.get("c.getDetails");
        ITPMRecAction.setCallback(this, function(Res){
            console.log('Res.getState()--->'+Res.getState());
            if(Res.getState() == "SUCCESS") {
                console.log(JSON.stringify(Res.getReturnValue()));
                component.set("v.isAdminUser",Res.getReturnValue());
                
            }
            else if(Res.getState() == "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            });                        
        $A.enqueueAction(ITPMRecAction);   
    },
    
   /* handleRefresh: function(component,event,helper){
        helper.loadInit(component,event,helper);
        $A.get('e.force:refreshView').fire();
        console.log('handleRefresh initiated');
    }, */
    
    loadInit: function(component,event,helper){
        var rId = component.get("v.recordId");
        if(rId != undefined){
        var ITPMRecAction = component.get("c.getITProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
            
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMObj",ITProjectIntakeInfo);
                var UId7=component.get("v.ITPMObj.IT_Program_Manager__c");
                var alink7='/lightning/r/User/'+UId7+'/view';
                component.set("v.link7",alink7);
                var UId1=component.get("v.ITPMObj.Alternate_Project_Manager__c");
                var alink1='/lightning/r/User/'+UId1+'/view';
                component.set("v.link1",alink1);
                var UId2=component.get("v.ITPMObj.LastModifiedById");
                var alink2='/lightning/r/User/'+UId2+'/view';
                component.set("v.link2",alink2);
                 var UId3=component.get("v.ITPMObj.CreatedById");
                var alink3='/lightning/r/User/'+UId3+'/view';
                component.set("v.link3",alink3);
                var UId4=component.get("v.ITPMObj.Analyst__c");
                var alink4='/lightning/r/User/'+UId4+'/view';
                component.set("v.link4",alink4);
                var sharePURL=component.get("v.ITPMObj.Sharepoint_URL__c");
                var alink5=sharePURL;
                component.set("v.link5",alink5);
                //alert(sharePURL);
                var MSURL=component.get("v.ITPMObj.MS_Teams_URL__c");
                var alink6=MSURL;
                component.set("v.link6",alink6);
                var CRURL=component.get("v.ITPMObj.CR_Name__c");
                var CRID =component.get("v.ITPMObj.BMC_Change_Request__c");
                var alink8="/apex/BMCServiceDesk__ConsoleRedirect?formulaFieldName=ChangeRequestLaunchConsole&recordName="+CRURL+"&recordId="+CRID+"&isdtp=vwuiTheme=Theme3&formLayoutId=";
				component.set("v.link8",alink8);

            }
            
            else if(Res.getState() == "ERROR"){
                
            }
            });
                       
        $A.enqueueAction(ITPMRecAction); 
        helper.loadCurrentUserProfile(component,event,helper);
		} 
    }
})