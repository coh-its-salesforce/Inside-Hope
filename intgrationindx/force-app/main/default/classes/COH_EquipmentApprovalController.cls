public class COH_EquipmentApprovalController {
    
    public Ergonomic_Self_Assessment__c ergObj {get; set;}
    public boolean approved {get; set;}
    private set<string> approvalSet = new Set<string>{'Yes', 'No'};
    public COH_EquipmentApprovalController(Apexpages.standardController con){
        String recID = Apexpages.currentPage().getparameters().get('Id');
        approved = false;
        if(string.isNotBlank(recID)){
          ergObj = [Select id, Name, Equipment_1__c, Equipment_1_Received_Date__c, Equipment_1_Required__c,Identify_Specific_Item_1__c, 
                             Equipment_2__c, Equipment_2_Received_Date__c, Equipment_2_Required__c,Identify_Specific_Item_2__c,
                             Equipment_3__c, Equipment_3_Received_Date__c, Equipment_3_Required__c,Identify_Specific_Item_3__c,
                             Equipment_4__c, Equipment_4_Received_Date__c, Equipment_4_Required__c,Identify_Specific_Item_4__c,
                             Equipment_5__c, Equipment_5_Received_Date__c, Equipment_5_Required__c,Identify_Specific_Item_5__c,
                             Equipment_6__c, Equipment_6_Received_Date__c, Equipment_6_Required__c,Identify_Specific_Item_6__c,
                             Equipment_7__c, Equipment_7_Received_Date__c, Equipment_7_Required__c,Identify_Specific_Item_7__c,
                             Equipment_8__c, Equipment_8_Received_Date__c, Equipment_8_Required__c,Identify_Specific_Item_8__c,
                             Equipment_9__c, Equipment_9_Received_Date__c, Equipment_9_Required__c,Identify_Specific_Item_9__c,
                             Equipment_10__c, Equipment_10_Received_Date__c, Equipment_10_Required__c,Identify_Specific_Item_10__c,
                             Equipment_11__c, Equipment_11_Received_Date__c, Equipment_11_Required__c,Identify_Specific_Item_11__c,
                             Equipment_1_Approval__c, Equipment_1_comment__c, Equipment_2_Approval__c, Equipment_2_comment__c, 
                             Equipment_3_Approval__c, Equipment_3_comment__c, Equipment_4_Approval__c, Equipment_4_comment__c, 
                             Equipment_5_Approval__c, Equipment_5_comment__c, Equipment_6_Approval__c, Equipment_6_comment__c,
                             Equipment_7_Approval__c, Equipment_7_comment__c, Equipment_8_Approval__c, Equipment_8_comment__c,
                             Equipment_9_Approval__c, Equipment_9_comment__c, Equipment_10_Approval__c, Equipment_10_comment__c,
                             Equipment_11_Approval__c, Equipment_11_comment__c,
                             Approved__c, User__c, Employee_ID__c from 
                             Ergonomic_Self_Assessment__c where id=:recID]; 
            approved = (ergObj.Equipment_1__c == null || (ergObj.Equipment_1__c != null && approvalSet.contains(ergObj.Equipment_1_Approval__c))) &&
                       (ergObj.Equipment_2__c == null || (ergObj.Equipment_2__c != null && approvalSet.contains(ergObj.Equipment_2_Approval__c))) &&
                       (ergObj.Equipment_3__c == null || (ergObj.Equipment_3__c != null && approvalSet.contains(ergObj.Equipment_3_Approval__c))) &&
                       (ergObj.Equipment_4__c == null || (ergObj.Equipment_4__c != null && approvalSet.contains(ergObj.Equipment_4_Approval__c))) &&
                       (ergObj.Equipment_5__c == null || (ergObj.Equipment_5__c != null && approvalSet.contains(ergObj.Equipment_5_Approval__c))) &&
                       (ergObj.Equipment_6__c == null || (ergObj.Equipment_6__c != null && approvalSet.contains(ergObj.Equipment_6_Approval__c))) &&
                       (ergObj.Equipment_7__c == null || (ergObj.Equipment_7__c != null && approvalSet.contains(ergObj.Equipment_7_Approval__c))) &&
                       (ergObj.Equipment_8__c == null || (ergObj.Equipment_8__c != null && approvalSet.contains(ergObj.Equipment_8_Approval__c))) &&
                       (ergObj.Equipment_9__c == null || (ergObj.Equipment_9__c != null && approvalSet.contains(ergObj.Equipment_9_Approval__c))) &&
                       (ergObj.Equipment_10__c == null || (ergObj.Equipment_10__c != null && approvalSet.contains(ergObj.Equipment_10_Approval__c))) &&
                       (ergObj.Equipment_11__c == null || (ergObj.Equipment_11__c != null && approvalSet.contains(ergObj.Equipment_11_Approval__c)));
            if(approved){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Request has been approved already.');
                ApexPages.addMessage(myMsg);
            }
        }else{              
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid ID.');
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void doApprove(){
        try{
            
            
            database.update(ergObj);
            system.debug('==ergObj.Equipment_1_Approval__c===='+ergObj.Equipment_1_Approval__c);
            system.debug('==ergObj.Equipment_2_Approval__c===='+ergObj.Equipment_2_Approval__c);
            system.debug('==ergObj.Equipment_3_Approval__c===='+ergObj.Equipment_3_Approval__c);
            system.debug('==ergObj.Equipment_4_Approval__c===='+ergObj.Equipment_4_Approval__c);
            system.debug('==ergObj.Equipment_5_Approval__c===='+ergObj.Equipment_5_Approval__c);
            approved = (ergObj.Equipment_1__c == null || (ergObj.Equipment_1__c != null && approvalSet.contains(ergObj.Equipment_1_Approval__c))) &&
                       (ergObj.Equipment_2__c == null || (ergObj.Equipment_2__c != null && approvalSet.contains(ergObj.Equipment_2_Approval__c))) &&
                       (ergObj.Equipment_3__c == null || (ergObj.Equipment_3__c != null && approvalSet.contains(ergObj.Equipment_3_Approval__c))) &&
                       (ergObj.Equipment_4__c == null || (ergObj.Equipment_4__c != null && approvalSet.contains(ergObj.Equipment_4_Approval__c))) &&
                       (ergObj.Equipment_5__c == null || (ergObj.Equipment_5__c != null && approvalSet.contains(ergObj.Equipment_5_Approval__c))) &&
                       (ergObj.Equipment_6__c == null || (ergObj.Equipment_6__c != null && approvalSet.contains(ergObj.Equipment_6_Approval__c))) &&
                       (ergObj.Equipment_7__c == null || (ergObj.Equipment_7__c != null && approvalSet.contains(ergObj.Equipment_7_Approval__c))) &&
                       (ergObj.Equipment_8__c == null || (ergObj.Equipment_8__c != null && approvalSet.contains(ergObj.Equipment_8_Approval__c))) &&
                       (ergObj.Equipment_9__c == null || (ergObj.Equipment_9__c != null && approvalSet.contains(ergObj.Equipment_9_Approval__c))) &&
                       (ergObj.Equipment_10__c == null || (ergObj.Equipment_10__c != null && approvalSet.contains(ergObj.Equipment_10_Approval__c))) &&
                       (ergObj.Equipment_11__c == null || (ergObj.Equipment_11__c != null && approvalSet.contains(ergObj.Equipment_11_Approval__c))) ;
            system.debug('======='+approved);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.confirm,'Request has saved successfully.');
            ApexPages.addMessage(myMsg);
        }catch(Exception e){apexpages.addMessages(e); }
    }
    
    public void saveRecord(){
        try{
            database.update(ergObj);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.confirm,'Date updated Successfully');
            ApexPages.addMessage(myMsg);
        }catch(Exception e){apexpages.addMessages(e); }
    }
}