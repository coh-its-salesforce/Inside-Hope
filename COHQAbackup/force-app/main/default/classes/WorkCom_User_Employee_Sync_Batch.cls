global class WorkCom_User_Employee_Sync_Batch  implements Database.Batchable<sObject>{
	//String query = 	'Select Email, EmployeeNumber, PER_Status__c, FirstName, LastName, Home_Phone__c, Work_Phone__c, Title, Mgr__r.Id, Id ' +
    //    			'From User u Where IsActive = true and u.EmployeeNumber != null ';
	String query = 	'Select Email, EmployeeNumber, PER_Status__c, FirstName, LastName, Home_Phone__c, Work_Phone__c, Title, Mgr__r.Id, Id ' +
        			'From User u Where UserType = \'Standard\' and IsActive = true and u.EmployeeNumber != null '+(Test.isRunningTest()?' LIMIT 100':'');// +
        			//'  and Id not IN (Select UserId From Employee )';

    global Database.querylocator start(Database.BatchableContext BC){
                return Database.getQueryLocator(query);}
    
    global void execute(Database.BatchableContext BC, List<User> scope){
       List<Employee> ListEmployeeToInsert = new List<Employee>();
    
       for(User s : scope) {
		    Employee e = new Employee();
            e.Email = s.Email;
            e.EmployeeNumber = s.EmployeeNumber;
            e.EmployeeStatus = s.PER_Status__c;
            e.FirstName = s.FirstName;
            e.LastName = s.LastName;
            e.HomePhone = s.Home_Phone__c;
            e.WorkPhone = s.Work_Phone__c;
            e.StatusAsOf = Datetime.now();
            e.Employee_Title__c = s.Title;
            e.WorkerType = 'Employee';
            if (s.Mgr__r.Id != null) {
            	e.ManagerId__c = s.Mgr__r.Id;//using custom field instead because of difficulties with standard field
           	}
            e.UserId__c = s.Id;
            e.User_Lookup__c = s.id;//added 20210203 by FSalinas. Links Employee to User record
            ListEmployeeToInsert.add(e);
        }

    	if(!ListEmployeeToInsert.isEmpty()){
            try {
				Schema.SObjectField f = Employee.Fields.UserId__c;
				Database.UpsertResult [] cr = Database.upsert(ListEmployeeToInsert, f, false);
        		//insert ListEmployeeToInsert ;
            } catch (exception e) {
            	system.debug('WorkCom_User_Employee_Sync_Batch exception: ' + e.getMessage());
            }
    	}
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
}