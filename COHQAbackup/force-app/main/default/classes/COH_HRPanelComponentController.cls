public class COH_HRPanelComponentController {
    public string panelNamestr {get; set;}
    
    public List<HR_Portal_Panel_Link__c> getLinkList(){
        List<HR_Portal_Panel_Link__c> recList = new List<HR_Portal_Panel_Link__c>();
        recList = [Select id, Name, Panel_Name__c, Link_Label__c, Link_URL__c, Order__c from HR_Portal_Panel_Link__c  
                   where Display__c = true and Panel_Name__c =: panelNamestr order by Order__c];
        return recList;
    }
    
    @AuraEnabled
    public static List<HR_Portal_Panel_Link__c> getpanelLinkList(string panelname){
        system.debug('==panelname====='+panelname);
        List<HR_Portal_Panel_Link__c> recList = new List<HR_Portal_Panel_Link__c>();
        recList = [Select id, Name, Panel_Name__c, Link_Label__c, Link_URL__c, Order__c from HR_Portal_Panel_Link__c  
                   where Display__c = true and Panel_Name__c =: panelname order by Order__c];
        return recList;
    }

}