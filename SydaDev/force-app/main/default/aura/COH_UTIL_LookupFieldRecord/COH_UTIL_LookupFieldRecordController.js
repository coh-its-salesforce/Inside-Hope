({
    selectRecord : function(component, event, helper){      
        var selectedRecord = component.get("v.mRecord");
        var compEvent = component.getEvent("newLookupValueSelected");
        compEvent.setParams({"lookupFieldResult" : selectedRecord });
        compEvent.fire();
    }
})