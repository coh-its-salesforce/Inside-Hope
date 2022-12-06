({
	leaveAComment: function(component, event, helper) {
        
        var commentValue=component.get("v.comment");
        var action = component.get("c.submitAComment");
         action.setParams({
            "comment" : commentValue,
            "subject" : component.get("v.Subject"),
            "email" : component.get("v.Email"),
            "PageSource":component.get("v.article.Designative_Type__c")
         });
        alert("your comment has been submitted successfully!!")
        component.set("v.comment",null);
        component.set("v.Subject",null);
        component.set("v.Email",null);
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                
                }
        	});
        	$A.enqueueAction(action);
    },
	UserEmail : function(component, event, helper) {
	var action = component.get("c.FetchUserEmail");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
	},
    /*approvedComments: function(component, event, helper) {
        
        var articleId=component.get("v.article.Id");
         
        var action = component.get("c.getApprovedComments");
        action.setParams({
            "recId" : articleId
         });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                component.set("v.ApprovedComments",a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }*/
})