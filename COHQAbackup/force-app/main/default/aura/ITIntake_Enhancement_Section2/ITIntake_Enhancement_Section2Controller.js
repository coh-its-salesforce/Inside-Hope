({
    
	/*doInit : function(component,event,helper) {                        
        helper.loadData(component, helper);
    }, */
    handleEdit: function(component,event,helper){
        component.set("v.isEdit", true);
    },
    handleCancel: function(component,event,helper){
        component.set("v.isEdit", false);
    },
    primaryISCChange:function(component,event,helper){
        var pIscVal = component.find("primaryIsc").get("v.value");
        console.log('pIscVal====>'+pIscVal);//ITadvisor
        var ITadvisorMap = new Map([["Patient Care & Clinical Systems","Kanschat, Judy"],
                                    ["Revenue Cycle/Patient Access Systems","Cowan, Skye"],
                                    ["Finance & Business Support Systems","Holthaus, John"],
                                    ["Research Systems","Limaye, Jayant"],
                                    ["Enterprise Data Mgmt & Analytics","Ady, Kevin"],
                                    ["IT Infrastructure","Thomas, Jim"]
                              ]);
        var ITadvisorVal = ITadvisorMap.get(pIscVal);
        component.find("ITadvisor").set("v.value",ITadvisorVal);
        console.log('ITadvisorVal====>'+ITadvisorVal);
        var ISCPMMap = new Map([["Patient Care & Clinical Systems","Bhattacharya, Gautam"],
                                    ["Revenue Cycle/Patient Access Systems","Cowan, Skye"],
                                    ["Finance & Business Support Systems","Goel, Amyth"],
                                    ["Research Systems","Roberts, Laura"],
                                    ["Enterprise Data Mgmt & Analytics","Ady, Kevin"],
                                    ["IT Infrastructure","Chavez, Denise"]
                              ]);
        var ISCPMVal = ISCPMMap.get(pIscVal);
        component.find("ISCPM").set("v.value",ISCPMVal);
        console.log('ISCPMVal====>'+ISCPMVal);
    },
    handleSuccess: function(component,event,helper){
        var parentId = component.get("v.parentId");
        
        
        // helper.loadData(component, helper);
        component.set("v.isEdit", false);
        //alert("record saved successfullty.");
        var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({
                        "title": "",
                        "message": "Record updated successfully",
                        "type": "success"
                    });
                toastEvent.fire();
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
})