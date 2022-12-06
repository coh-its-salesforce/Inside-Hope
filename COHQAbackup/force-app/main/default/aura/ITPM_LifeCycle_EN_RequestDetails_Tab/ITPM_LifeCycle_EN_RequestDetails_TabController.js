({
	init : function(component,event,helper) {                        
        var rId = component.get("v.recordId");
        var ITPMRecAction = component.get("c.getITProjectIntake"); 
        ITPMRecAction.setParams({
            "recordId":rId
        });
        ITPMRecAction.setCallback(this, function(Res){
            if(Res.getState() == "SUCCESS") {
                var ITProjectIntakeInfo=Res.getReturnValue();
                component.set("v.ITPMObj",ITProjectIntakeInfo);
                var ITP_Id=component.get("v.ITPMObj.ITS_Intake_Request__c");
                var alink1='/lightning/r/TPO_Project_Portfolio__c/'+ITP_Id+'/view';
                component.set("v.link1",alink1);
                /* var user_Id=component.get("v.ITPMObj.ITS_Intake_Request__r.Business_Owner__c");
                var alink2='/lightning/r/User/'+user_Id+'/view';
                component.set("v.link2",alink2);
                var user_Id1=component.get("v.ITPMObj.ITS_Intake_Request__r.Business_Sponsor__c");
                var alink3='/lightning/r/User/'+user_Id1+'/view';
                component.set("v.link3",alink3); */
                var user_Id2=component.get("v.ITPMObj.ITS_Intake_Request__r.IT_Advisor1__c");
                var alink4='/lightning/r/User/'+user_Id2+'/view';
                component.set("v.link4",alink4);
                var user_Id3=component.get("v.ITPMObj.ITS_Intake_Request__r.ISC_PM__c");
                var alink5='/lightning/r/User/'+user_Id3+'/view';
                component.set("v.link5",alink5);
                var user_Id4=component.get("v.ITPMObj.ITS_Intake_Request__r.Submitter_Name__c");
                var alink6='/lightning/r/User/'+user_Id4+'/view';
                component.set("v.link6",alink6);
            }
            else if(Res.getState() == "ERROR"){
                
            }
            });                        
            $A.enqueueAction(ITPMRecAction); 
    }
})