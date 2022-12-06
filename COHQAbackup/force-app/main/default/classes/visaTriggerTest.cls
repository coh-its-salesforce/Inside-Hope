@isTest
public class visaTriggerTest{
static testmethod void testTrigger(){

visa__c Visa = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Case_Type__c= 'Amendment',Type_of_Visa__c ='J-1',
Proposed_Visa_End_Date__c = system.today().adddays(731),Proposed_Visa_Start_Date__c = system.today());
insert visa;    
visa__c Visa1 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Case_Type__c= 'Amendment',Type_of_Visa__c ='J-1',
Proposed_Visa_End_Date__c = system.today().adddays(366),Proposed_Visa_Start_Date__c = system.today());
insert visa1;    
visa__c Visa2 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Case_Type__c= 'Amendment',Type_of_Visa__c ='J-1',
Proposed_Visa_End_Date__c = system.today().adddays(5),Proposed_Visa_Start_Date__c = system.today());
insert visa2;    
visa__c Visa3 = new visa__c(Proposed_Individual_First_Name__c ='apFirst',Proposed_Individual_Last_Name__c ='Last name',Case_Type__c= 'Amendment',Type_of_Visa__c ='J-1',
Proposed_Visa_End_Date__c = system.today(),Proposed_Visa_Start_Date__c = system.today());
insert visa3;

}
}