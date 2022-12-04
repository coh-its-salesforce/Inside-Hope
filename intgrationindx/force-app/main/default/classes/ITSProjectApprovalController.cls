public with sharing class ITSProjectApprovalController {
    
    public List<ITS_Project_Request__c> selectedProject {get ; set;}
    public ITS_Project_Request__c acc {get; set;}
    private ITS_Project_Request__c tempProject;
    
    public ITSProjectApprovalController(ApexPages.StandardController controller){
        acc = new ITS_Project_Request__c ();
        tempProject = (ITS_Project_Request__c)controller.getRecord();
    }
    
      
    
    public ITSProjectApprovalController(ApexPages.StandardSetController controller){
        
        selectedProject = new List<ITS_Project_Request__c>();
        
        List<ITS_Project_Request__c> Project = controller.getSelected() ;
        
        if(Project != null && Project.size() > 0){
            for(ITS_Project_Request__c  a : [Select id,Name from ITS_Project_Request__c where id in : Project]){
                ITS_Project_Request__c newAcc = new ITS_Project_Request__c(id=a.id, Name = a.Name);
                selectedProject.add(newAcc);
            }
        }
        if(selectedProject.isEmpty()){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Record Selected');
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    public pageReference doSingleSave(){
        if(acc != null && tempProject  != null ){
                          
            if(acc.Commented__c== null || acc.Commented__c== ''){
                     acc.Commented__c.addError('Please enter comment.'); 
            }
            else{
                try{
                ITS_Project_Request__c newAcc = new ITS_Project_Request__c(id=tempProject.id);
                newAcc.Approve_Reject_User__c = UserInfo.getUserID();
                newAcc.Approve_Rejected_Date__c= system.now();
                newAcc.Commented__c= acc.Commented__c;
                newAcc.Approve_Status__c  = 'Need More Details' ;
                update newAcc;
                return new pageReference('/'+newAcc.id).setRedirect(true);
                }catch(Exception e){
                    ApexPages.addMessages(e); 
                    return null;
                }
            
            }
        }        
        else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Invalid Record.');
           ApexPages.addMessage(myMsg); 
        }
        
        
        return null;
    
    }
    
    
    public pageReference DoSave(){
        
        boolean  errorflag = false;
        List<ITS_Project_Request__c> accountsToUpdate =new  List<ITS_Project_Request__c>();
        for(ITS_Project_Request__c a : selectedProject){
            ITS_Project_Request__c newAcc = new ITS_Project_Request__c(id=a.id);
            newAcc.Approve_Reject_User__c = UserInfo.getUserID();
            newAcc.Approve_Rejected_Date__c= system.now();
            newAcc.Approve_Status__c= 'Need More Details';
            newAcc.Commented__c = a.Commented__c;
            if(a.commented__c == null || a.commented__c == ''){
                a.commented__c.addError('Please enter comment.'); 
                errorflag = true;
            }
            accountsToUpdate.add(newAcc );
        }
        try{
            if(!errorflag){
                update accountsToUpdate;
                Schema.DescribeSObjectResult r = ITS_Project_Request__c.sObjectType.getDescribe();
                String keyPrefix = r.getKeyPrefix();
                return new pageReference('/'+keyPrefix).setRedirect(true);
            }
        }catch(Exception e){
            apexpages.addMessages(e);
        }
        return null;
    }
    
}