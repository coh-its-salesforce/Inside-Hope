/*==========================================================================================================================+
 |  HISTORY                                                                  
 |                                                                           
 |  DATE             DESCRIPTION                               
 |  ====             =========== 
 |  9/9/2015        Initial Creation.  Validation cehck for mutiple Secondary.  
  
 +==========================================================================================================================*/

public class DepartmentOperations{

public static void mutipleSecondaryCheck(List<Secondary_Department__c> secondaryLst){
   /* List<Id> departmentIdLst = new List<Id>();
    Map<Id,List<Secondary_Department__c>> mapDeptSeconday = new Map<Id,List<Secondary_Department__c>>();
    for(Secondary_Department__c secodObj : secondaryLst){
        departmentIdLst.add(secodObj.Department_Name__c);
    }
    
    if(!departmentIdLst.isEmpty()){
        List<Secondary_Department__c> departmentLst = [Select id,Department_Name__c from Secondary_Department__c where Department_Name__c in:departmentIdLst];
        for(Secondary_Department__c secondaryObj : departmentLst){
            if(mapDeptSeconday.containsKey(secondaryObj.Department_Name__c))
                mapDeptSeconday.get(secondaryObj.Department_Name__c).add(secondaryObj);
            else{
                List<Secondary_Department__c> tempLst = new List<Secondary_Department__c>();
                tempLst.add(secondaryObj);
                mapDeptSeconday.put(secondaryObj.Department_Name__c,tempLst);
            }
        }
    }
    
    for(Secondary_Department__c secObj : secondaryLst){
        if(mapDeptSeconday.containsKey(secObj.Department_Name__c))
            secObj.addError(Label.Mutiple_Secondary);
    }*/
    
}

}