public class COH_CEAFormTriggerHelper {
    private static List<COH_CEAForm__Share> mShareRecordsToAdd;
    
    public static void setNewApprovers(List<COH_CEAForm__c> updatedCEAForms) {
        mShareRecordsToAdd = new List<COH_CEAForm__Share>();
        
        for (COH_CEAForm__c i : updatedCEAForms) {
            if (i.COH_CEA_ApprovalStatus__c == 'Pending Department/VP Approval') {
                shareRecordWithDepartmentApprovals(i);
            }
            else if (i.COH_CEA_ApprovalStatus__c == 'Pending Conditional Approvals') {
                setConditionalApprovers(i);
            }
        }
        if (mShareRecordsToAdd != null && mShareRecordsToAdd.size() > 0) {
         	Database.insert(mShareRecordsToAdd, false);   
        }
    }
    
    private static void shareRecordWithDepartmentApprovals(COH_CEAForm__c CEAForm) {
        if (CEAForm.COH_CEA_ManagerInvestigator__c != null) {
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ManagerInvestigator__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_DirectorChair__c != null) {
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_DirectorChair__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_VicePresident__c != null) {
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_VicePresident__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }        
    }	
    
    private static void setConditionalApprovers(COH_CEAForm__c CEAForm) {
        Integer approvalCount = 0;
        
        if (CEAForm.COH_CEA_ConditionalApprover1__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover1__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover1__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover2__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover2__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover2__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover3__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover3__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover3__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover4__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover4__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover4__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover5__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover5__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover5__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover6__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover6__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover6__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover7__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover7__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover7__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover8__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover8__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover8__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        if (CEAForm.COH_CEA_ConditionalApprover9__c != null) {
            approvalCount++;
            CEAForm.put('COH_CEA_Approver'+approvalCount+'__c', CEAForm.COH_CEA_ConditionalApprover9__c);
            COH_CEAForm__Share tempShareRecord = createShareRecord(CEAForm.COH_CEA_ConditionalApprover9__c, CEAForm);
            if (tempShareRecord != null) {
                mShareRecordsToAdd.add(tempShareRecord);
            }
        }
        CEAForm.COH_CEA_ApprovalCount__c = approvalCount;
    }    
    
    /*
     * 
     */
    private static COH_CEAForm__Share createShareRecord(Id userId, COH_CEAForm__c recordToShare) {
        COH_CEAForm__Share newShareRecord;
        if (userId != recordToShare.OwnerId) {
            newShareRecord = new COH_CEAForm__Share();
            newShareRecord.UserOrGroupId = userId;
            newShareRecord.ParentId = recordToShare.Id;
            newShareRecord.AccessLevel = 'Edit';	            
        }
        return newShareRecord;
    }
}