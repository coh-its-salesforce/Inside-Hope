/*
 * This class contains the methods for handling trigger events for Lead objects.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHLeadHelper {
    
    private static Boolean DO_NOT_DELETE_LEAD = false;
    private static Boolean DELETE_LEAD = true;
    
    /*
     * This method handles all trigger calls for the Lead object.
     * 
     */
    /*public static void processLeads() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isInsert) {
				WTPProcessLeadUtil.processLeads(Trigger.new, DELETE_LEAD);
            }
        }
    }*/
    
    public static void beforeUpdate(List<Lead> newList,Map<Id,Lead> oldMap){
        for(Lead inx : newList){
            if(inx.Street != oldMap.get(inx.Id).Street 
               || inx.City != oldMap.get(inx.Id).City
               || inx.State != oldMap.get(inx.Id).State
               || inx.Country != oldMap.get(inx.Id).Country
               || inx.PostalCode != oldMap.get(inx.Id).PostalCode){
                   String address = (inx.Street!=null?inx.Street:'')+(inx.City!=null?inx.City:'')+(inx.State!=null?inx.State:'')+(inx.Country!=null?inx.Country:'')+(inx.PostalCode!=null?inx.PostalCode:'');
                   COHAccountHelper.getCordinates(address,inx.Id,'Lead');
               }
        }
    }
    
    public static void afterInsert(List<Lead> newList){
        for(Lead inx : newList){
            String address = (inx.Street!=null?inx.Street:'')+(inx.City!=null?inx.City:'')+(inx.State!=null?inx.State:'')+(inx.Country!=null?inx.Country:'')+(inx.PostalCode!=null?inx.PostalCode:'');
            COHAccountHelper.getCordinates(address,inx.Id,'Lead');
        }
        
    }
}