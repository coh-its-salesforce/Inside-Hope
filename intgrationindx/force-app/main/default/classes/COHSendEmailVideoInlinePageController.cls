public class COHSendEmailVideoInlinePageController {
    public case caseObj {get; set;}
    public COHSendEmailVideoInlinePageController(Apexpages.StandardController con){
        this.caseObj = (Case)con.getRecord();
    }
    
    public void sendVideoEmail(){
        if(this.caseObj.Id != null){
            try{
                Map<String, Object> response = COHCaseInsuranceTabController.sendVideoEmail(this.caseObj.Id );
                boolean isSuccess = (Boolean)response.get('issuccess');
                string message =  (string)response.get('message');
                ApexPages.Message myMsg;
                if(isSuccess){
                    myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,message);
           		}else{
                   myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
            	}
                ApexPages.addMessage(myMsg);
            }Catch(Exception ex){
                Apexpages.addMessages(ex);
            }
        } else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Case id');
            ApexPages.addMessage(myMsg);
        }
    }
}