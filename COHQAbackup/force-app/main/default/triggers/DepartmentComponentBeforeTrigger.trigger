/*
*   Date: 28-Aug-2015
*   Desc: Created new trigger to validate duplicate order number
*/
trigger DepartmentComponentBeforeTrigger on Department_Components__c (before insert, before update) {
    if(SIRP_DepartmentPortal.byPassDuplicateOrderValidation) return;
    Set<Id> depIds = new Set<Id>();
    for(Department_Components__c dc : trigger.new) {
        
        depIds.add(dc.Department_Name__c);
    }
    List<Department_Components__c> existingDepartments = [Select Id, Order__c, Department_Name__c from Department_Components__c where Department_Name__c IN :depIds];
    Map<Id, Set<String>> mapOrdersWithDepartment = new Map<Id, Set<String>>();
    for(Department_Components__c existingDC : existingDepartments) {
        system.debug('existingDC.Id : '+existingDC.Id);
        system.debug('trigger.newMap : '+trigger.newMap);
        
        //if(existingDC.Id != null && trigger.newMap.containsKey(existingDC.Id)) continue;
        if(mapOrdersWithDepartment.containsKey(existingDC.Department_Name__c)) {
            Set<String> tempOrders = mapOrdersWithDepartment.get(existingDC.Department_Name__c);
            tempOrders.add(existingDC.Order__c);
            mapOrdersWithDepartment.put(existingDC.Department_Name__c, tempOrders);
        } else {
            mapOrdersWithDepartment.put(existingDC.Department_Name__c, new Set<String>{existingDC.Order__c});
        }
    } 
    system.debug('mapOrdersWithDepartment : '+mapOrdersWithDepartment);
    for(Department_Components__c dc : trigger.new) {
        if(mapOrdersWithDepartment.containsKey(dc.Department_Name__c)) {
            Set<String> existingOrders = mapOrdersWithDepartment.get(dc.Department_Name__c);
            if((Trigger.isInsert && existingOrders.contains(dc.Order__c)) || (Trigger.isUpdate && Trigger.oldMap.get(dc.Id).Order__c != Trigger.newMap.get(dc.Id).Order__c) && existingOrders.contains(dc.Order__c)) {
                dc.Order__c.addError('Please remove duplicate order number.');
                return;
            }
                        
        }
        
    }

}