public class EmployeeAssessmentEmailController {
    
    public EmployeeAssessmentEmailController(ApexPages.StandardController controller){
        
    }
    
    public pageReference updateFlag(){
    	id recId = Apexpages.currentPage().getParameters().get('Id');
        if(recId != null){
            EmployeeCrisisAssessment csa = new EmployeeCrisisAssessment(Id=recId);
            csa.Notify_Employee__c = true;
            update csa;
            return new pageReference('/'+csa.Id).setRedirect(true);
        }
        return null;
    }
        
    
    
    
}