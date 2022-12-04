@isTest
private class SDAddToMassMergeTest{
    @isTest
    private static void SDAddToMassMergeTest(){
        Integer numJobsToCreate = 20;
        List<EHS_Risk_Assessment_Questionaire__c> selectedEHSRiskAssessmentQuestionnaires = [
            SELECT Id, 
            name 
            from EHS_Risk_Assessment_Questionaire__c 
            LIMIT : numJobsToCreate
        ];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(selectedEHSRiskAssessmentQuestionnaires);
        ssc.setSelected(selectedEHSRiskAssessmentQuestionnaires);
        SDAddToMassMerge sdatmm = new SDAddToMassMerge(ssc);
        String objectNameTest = '[SDAddToMassMerge Test]';
        sdatmm.createMassMergeJobs();
        Integer numJobsCreated = Database.countQuery(
            'SELECT COUNT() '
            + 'FROM SDOC__SDJob__c ' 
            + 'WHERE SDOC__ObjApiName__c=\''+objectNameTest+'\''
        );
        //System.assert(numJobsCreated == numJobsToCreate);
    }
}