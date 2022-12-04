@isTest
public class COH2_FacultyProfileController_Test {
    
    private static testmethod void facultyProfileUnitTest(){
        
        COH2_Faculty_Final__c ff = new COH2_Faculty_Final__c();
        ff.Name = '123456';
        ff.COH2_Awards__c = 'Award1, Award2';
        ff.COH2_FirstName__c = 'FirstName';
        ff.COH2_MiddleName__c = 'Md Name';
        ff.COH2_LastName__c = 'LastName';
        ff.COH2_Degrees2__c = 'Degree';
        ff.COH2_Education_Text__c = 'EducationText';
        ff.COH2_Memberships__c = 'Memberships';
        ff.COH2_Professional_Exp__c = 'ProfessionalExp';
        
        insert ff;
        Apexpages.StandardController controller = new Apexpages.StandardController(new COH2_Faculty_Final__c());
        Apexpages.currentPage().getparameters().put('EmpId', '123456');
        COH2_FacultyProfileController fpc = new COH2_FacultyProfileController(controller);
        fpc.finalFacultyObj.COH2_FirstName__c = 'ChangedName';
        fpc.finalFacultyObj.Start_Date__c = Date.today();
        
        fpc.doSave();
        fpc.finalFacultyObj.COH2_FirstName__c = null;
        fpc.finalFacultyObj.COH2_EmailAddress__c = '<deleted>@Email.address';
        fpc.doSave();
    }
}