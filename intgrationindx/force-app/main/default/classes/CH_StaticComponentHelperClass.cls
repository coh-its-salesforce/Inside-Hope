/* Name           :  CH_StaticComponentHelperClass
*  Created By     :   Persistent Systems Ltd
*  Created Date   :   Feb 11, 2015 
*  Description    :   This Class is Used for storing static variable required for Assignment engine and Alert Engine
*/

Global Class CH_StaticComponentHelperClass{

public static string InterpreterRoleName = 'Interpreter';
public static string FinancialCounselorRoleName = 'Financial Counselor';
public static string FinancialCounselorMngRoleName = 'Financial Counselor - Manager';
public static string CallTypeToExcludeFC = 'Consults';
public static string ManagerTeamRoleSuffix = ' - Manager';
public static string PatientDeniedStatus= 'Patient Denied Care';

public static string ReferredtoHOSPICE= 'Solid Tumor - Survivorship';
public static string StageSolidTumorfollowup='Solid Tumor - Follow Up';
public static string StatusNew='New';
public static string StageSolidTumorsurvivorship= 'Solid Tumor - Survivorship';
public static string StagePatientintake= 'Patient Intake';
public static string Orgwideemailadress= 'COH Care Coordination Application';
public static string CohEmailFolder= 'COH Templates';
public static string CH_CaseOwner = 'CH_Case Owner';
public static string CH_CaseOwnerServiceDesk = 'CH Case Owner Service Desk';
public static string CH_Assignement_email_template= 'Case_Coordinator_Email';
public static string CH_Manager_Role_Suffix= '- Manager';
public static string CH_Supervisors ='CH_Supervisors';
public static string CH_SupervisorsServiceDesk ='CH Supervisors Service Desk';
public static string PatientAccptedStatus= 'Patient Accepted';
public static string statuscaregiverfound='Caregiver found';
public static string statuscaregivernotfound='Caregiver not found';
public static boolean applyFixForSFissue1= True;
public static string NursePractitionerRoleName = 'Nurse Practitioner';
public static string TaskReassignmentUrl = 'apex/Ch_managerassignmentpage?caseId=';
public static string CareCoordinator = 'Care Coordination';
public static string CaseStagePIFA = 'Patient Intake - First Appointment';
public static string CaseStatusMDAppointed = 'MD Appointed';
public static string CaseStatusAppointmentDetailsUpdated = 'Patient Arrived';
}