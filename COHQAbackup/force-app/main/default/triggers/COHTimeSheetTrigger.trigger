/*
* Trigger for the Timesheet Week object.
* 
* Larry Kiang
* City of Hope 
* Copyright (c) 2019 
*  
* No portion of this code may be copied, transferred, or transmitted 
* in any form (written, electronic, or otherwise) without the prior 
* written consent from the City of Hope. 
*/

//
trigger COHTimeSheetTrigger on Timesheet_Week__c (after insert, after update) {
    List<Id> userListID = new List<Id>();
    for(Timesheet_Week__c SubmittedTimesheet : trigger.new) {
        if(SubmittedTimesheet.Status__c == 'Submitted') { 
            userListID.add(SubmittedTimesheet.User__c);
        }
    
         
    List<User> userList = [Select ID, Last_Timesheet_Submitted_End_Week__c from user where ID in :userListID];
    if (COHUtil.isValidList(userList)) {
        for(User u : userList) {
            u.Last_Timesheet_Submitted_End_Week__c = SubmittedTimesheet.Week_End_Date__c;
        }
    update userList;
    }
    }
}