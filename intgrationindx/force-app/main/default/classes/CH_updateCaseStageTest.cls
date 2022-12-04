@isTest(seeAllData=false)
public class CH_updateCaseStageTest{   
   
    
    static testMethod void testSurviorshipStage(){
        
        User u = CH_Test_SampleData.createUserRecord(1,'system administrator');
        
        Account accountRecord = CH_Test_SampleData.createCOHBusinessAccounts(1); 
        
        Case caseRecord = CH_Test_SampleData.createCase(1,accountRecord);       
        
        Status_Stage_Master__c status  = CH_Test_SampleData.CreateStage(CH_StaticComponentHelperClass.StageSolidTumorsurvivorship);
                
        Status_Stage_Master__c stage = CH_Test_SampleData.CreateStatus(CH_StaticComponentHelperClass.StageSolidTumorsurvivorship);
        
        //caseRecord.FkStage__c = stage.id;
        //caseRecord.FkStatus__c = status.id;
        caseRecord.Owner_Role__c = 'TestONCC'; 
        update caseRecord;
        
        System.runAs ( u ) {
        
            CaseteamRole tmRole = CH_Test_SampleData.CreateCaseTeamRole('TestONCC');
            insert tmRole; 
            
            CaseTeamMember ctm = new CaseTeamMember();
            ctm.ParentId = caseRecord.id;
            ctm.TeamRoleid = tmRole.id;
            ctm.memberid = u.id;
                   
            insert ctm;       
        
            Test.startTest();           
                           
            CH_updateCaseStage.UpdateCaseToSurvivorship(caseRecord.id);
            
            Case updatedCase = [select id, FkStage__c, Stage__c, FkStatus__c, status__c from Case where id =: caseRecord.id limit 1];
            system.assertEquals(updatedCase.Stage__c,CH_StaticComponentHelperClass.StageSolidTumorsurvivorship);
            system.assertEquals(updatedCase.status__c,CH_StaticComponentHelperClass.StageSolidTumorsurvivorship);

            Test.stopTest();
        }
    
    }    
   
}