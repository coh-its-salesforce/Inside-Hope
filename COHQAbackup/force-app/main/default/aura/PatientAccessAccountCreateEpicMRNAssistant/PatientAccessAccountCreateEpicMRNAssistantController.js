({
    doInit : function (component,event,helper) {
        var recordId = component.get('v.recordId');
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var inputVariables = [
            { name: "recordId", type : "String", value:recordId }
        ]
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("Patient_Access_Screenflow_Create_Epic_MRN_Assistant_Patient_Demographic_Only",inputVariables);
    }
})