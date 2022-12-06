public class COH_SIP_Secondary_Department_Controller {
    public List<Department__c> lstDepartment {get;set;}
    public String strUrl{get;set;}
    public COH_SIP_Secondary_Department_Controller(){        
        String isSecondary = ApexPages.currentPage().getParameters().get('isSecondary');
        String recordid = ApexPages.currentPage().getParameters().get('id');        
        if(!String.isEmpty(isSecondary) && isSecondary.equalsIgnoreCase('True')){            
            String strName;
            List<Secondary_Department__c> lstSecDepartments = [Select name from Secondary_Department__c where id=:recordid];
            if(lstSecDepartments.size() > 0)
            {
                strName = lstSecDepartments[0].name;  
                system.debug('strName: '+strName);
                lstDepartment = [Select Id, Name,Parent_Department__r.Name, Parent_Department__c,CalendersName__c, Description__c, Title__c, Image_Attachment_Id__c, Owner.Name, Owner.Email, LastModifiedBy.Name, LastModifiedBy.Email,Department_Additional_Description__c, MenuItem__c from Department__c where name = :strName limit 1];
                
                if(lstDepartment.size() > 0)
                {
                    system.debug('lstDepartment[0].id: '+lstDepartment[0].id);
                    strUrl = ('/apex/DepartmentPortal?id=' + lstDepartment[0].id);                    
                }
            }
        }
    } 
}