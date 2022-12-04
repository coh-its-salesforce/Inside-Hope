/******************************************************************************
* File Name..............:: COHTimeEffortController
* FileType...............:: Apex Class
* Created Date............:: 6/25/2015 
* Created By.............:: Sanjay Singh 
* Modified Date............:: 10/17/2016  
* Modified By.............:: Abhishek Kumar 
* Modified Date............:: 11/04/2016  
* Modified By.............:: Sanjay Singh
* ****************************************************************************
* Description............:: This class is controller class for visualforce page                                        
*                           Time sheet.
* ****************************************************************************/    
public with sharing class COHTimeEffortController {
    /**** Variable Declaration Starts Here**********/
    public List<projectWrapper> projectWrapperList {get; set;}
    public string selectedWeek {get; set;}
    public boolean isEditable {get; set;}
    public List<DateWrapper> weekDates {get; set;}
    public Date weekStartDate {get; set;}
    
    public Date WeekEndDate   {get; set;}
    public Timesheet_Week__c tsWeek {get; set;}
    public boolean isCurretWeek {get; set;}
    public boolean isInvalidWeek {get; set;}
    public boolean isSubmit ;
    public decimal grandTotal {get; set;}
    public Map<integer, decimal> totalMap {get;set;}
    public integer projectRoworder {get;set;}
    public string  componentId {get; set;}
    public boolean isCustomdate {get; set;}
    public Date dt {get; set;}
    public Time_record__c tr {get; set;}
    public String selectedTaskId {set;get;}
    public String selectedStageId {set;get;}
    public String selectedActivityType {set;get;}
    public String selectedActivitySubType {set;get;}
    public String selectedActivity {set;get;}
    public List<SelectOption> TasksForProjectsForUser {get; set;}
    public List<SelectOption> StageOfProjects {get; set;}    
    public List<SelectOption> CostCentersOfProjects {get; set;} 
    public List<SelectOption> Activities {get; set;}    
    public List<SelectOption> ActivityTypes {get; set;}    
    public List<SelectOption> ActivitySubTypes {get; set;} 
    public List<SelectOption> WorkHoursList {get; set;}    
    public List<SelectOption> Applications {get; set;}    
    public String Project_ID {get;set;}
    public string  lastSavedOn {get; set;}
    public boolean linkAgileAcceleratorToTimesheet {get; set;}
    public static string SystemDefault = 'Other System';
    public boolean isSpecialityAreaDisabled {set;get;}
    
    PUBLIC FINAL STRING INVALID_INPUT_VALUE = '-1';          // SelectList value that should return an error message
    PRIVATE STATIC FINAL INTEGER DEFAULT_NUMBER_OF_DAYS_TO_SHOW_USER_STORIES = -17;
    private static Integer mNumberOfDaysToShowUserStories;
    
    private Map<id, agf__ADM_Task__c> mSelectedUserStoryTasksMap;
    
    /****** variable declaration ends*************/
    
    
    // Constructor
    public COHTimeEffortController(){
        // Initialize variables
        isSpecialityAreaDisabled = false;
        isEditable = true;
        isCurretWeek = false;
        selectedWeek = '';
        tr = new Time_record__c();
        isCustomdate  = false;
        weekDates = new List<DateWrapper>();
        linkAgileAcceleratorToTimesheet = [SELECT Link_Agile_Accelerator_To_Timesheet__c FROM User WHERE id =: UserInfo.getUserId() LIMIT 1].Link_Agile_Accelerator_To_Timesheet__c;
        // By Default previous week should be selected on page load
        if ((Date.today().day() - Date.today().toStartofWeek().day()) < 3)
        {
            weekStartDate = Date.today().addDays(-7).toStartofWeek();
        }
        else
        {
            weekStartDate = Date.today().toStartofWeek();  
        } 
        WeekEndDate = weekStartDate.addDays(6);
        isSubmit = false;
        totalMap = new Map<integer , decimal>();
        grandTotal  = 0;     
        //StageOfProjects = getStageOfProjects();             // Not in use - TH 7/24/2017
        //CostCentersOfProjects = getCostCentersProjects();   // Not in use - TH 7/24/2017
        Applications = getApplicationsOfProjects();
        //WorkHoursList = getWorkHoursList();                 // Not in use - TH 7/24/2017
        findWeek(true);    
        //TasksForProjectsForUser = getTasksForProjectsForUser();   
        //ActivityTypes = getActivityTypes();
        //getActivitySubTypes();
        //getActivities();
        //getActivityDependents();
    }
    
    /*
     * For loading Applications for tasks related to the project
     */
    public List<SelectOption> getApplicationsOfProjects(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '---Select---'));
        
        Schema.DescribeFieldResult fieldResult = 
            IT_Portfolio_Management__c.ITS_Application__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    /*
     * For rendering custom date input section
     */
    public void enterCustom(){
        isCustomdate = true; 
        tr.Date__c = weekStartDate;
    }
    
    /* 
     * After entering custom date user click on Go Button then this method will get call
     */
    public void findCustomWeek(){
        if(tr.Date__c != null){
            // User should not be able to select future date
            if(tr.Date__c > date.today()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You cannot enter time for future date.')); 
                return ;
            }
            
            If(tr.Date__c.day() <= 30 && tr.Date__c.month() == 10 && tr.Date__c.year() == 2016)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'The new timesheet does not go beyond Oct 31 2016.')); 
                return ;
            }
            
            isCustomdate  = false;
            weekStartDate = tr.Date__c.toStartofWeek();
            weekEndDate = weekStartDate.addDays(6);
            findWeek(false);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter week start date')); 
        }
    }
    
    /*
     * Checks to see if a user is able to edit a timesheet once it has been submitted
     */
    public boolean checkUserAccess(){
        boolean flag  = false;
        
        TimesheetSetting__c ts = TimesheetSetting__c.getInstance();
        
        if(ts != null && ts.Can_Edit_Submitted_Timesheet__c ){
            flag= true;
        }
        
        return flag;
    }
    
    /*
     * This method will find week, means week start date and week end date. 
     * It will create week range string 
     * It checks if the timesheet is submitted for this week then user should not be able to edit it.
     */
    public void findWeek(boolean bFromcosntructor){
        System.debug('Find Week Started | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());
        If(weekStartDate.day() <= 31 && weekStartDate.month() == 10 && weekStartDate.year() == 2016)
        {
            isInvalidWeek = true;
        }
        else
        {
            isInvalidWeek = false;
        }
        
        tsWeek = new Timesheet_Week__c();
        projectWrapperList = new List<projectWrapper>();
        totalMap = new Map<integer, decimal>();
        Map<Date,decimal> tempMap = new Map<Date,decimal>();
        selectedWeek = weekStartDate.format() + ' - '+ WeekEndDate.format();
        lastSavedOn = '';
        if(weekStartDate != null && WeekEndDate != null){
            makeDateList();
            System.debug('User -----> ' + UserInfo.getUserId());
            List<Timesheet_Week__c> weekS = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                                                                         Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c,
                                                                         (Select id, Week__c, Name, Date__c, Activity_Sub_Type__c, Activity_Type__c, Cost_Center__c, Hours__c, Stage__c, Project_Task__c, IT_Portfolio_Management__c, System__c, Work_Hours__c, Work__c, Task__c, Task__r.Timesheet_Remaining_Hours__c, Task__r.agf__Starting_Hours__c from Time_Records__r WHERE NOT IT_Portfolio_Management__c = '' order by Date__c ASC)
                                                                         FROM Timesheet_Week__c where Week_Start_Date__c =:weekStartDate
                                                                         and Week_End_Date__c =:WeekEndDate and User__c=:UserInfo.getUserId() limit 1]);
            System.debug('weekS -----> ' + weekS);
            System.debug('Query to Run for variable weekS Run 196| CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());
            if(!weekS.isEmpty()) {
                tsWeek = weekS[0];   
                
                boolean isSubmitted = tsWeek.Status__c =='Submitted' ? true : false;
                if(isSubmitted){
                    if(checkUserAccess()){
                        isEditable = true;
                    }else{
                        isEditable = false;
                    }
                }else{
                    isEditable = true;  
                }    
                
                if(!tsWeek.Time_Records__r.isEmpty()){
                    integer i = 0;
                    
                    //Code to fetch last saved timesheet week
                    List<Timesheet_Week__c> tempweekS = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                                                                                     Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c, LastModifiedDate,
                                                                                     (Select id, Name, Date__c, Activity_Sub_Type__c, Activity_Type__c, Cost_Center__c, Hours__c, Stage__c, Project_Task__c, IT_Portfolio_Management__c, System__c, Work_Hours__c, Work__c, Task__c from Time_Records__r WHERE NOT IT_Portfolio_Management__c = '' order by IT_Portfolio_Management__r.Name ASC)
                                                                                     FROM Timesheet_Week__c where User__c=:UserInfo.getUserId()
                                                                                     Order By LastModifiedDate DESC
                                                                                     limit 1]);   
                    System.debug('Query to Run for variable tempweeks 221 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());

                    if(!tempweekS.isEmpty()) {
                        lastSavedOn = string.valueOf(tempweekS[0].Week_Start_Date__c) + ' - ' + string.valueOf(tempweekS[0].Week_End_Date__c);
                    }
                    
                    //Code to eliminate duplicate timerecords - Abhishek 22 Dec 2016
                    try
                    {
                        if(!isSubmitted && !bFromcosntructor)
                        {
                            Map<Id, Time_Record__c> mpToDelete = new Map<Id, Time_Record__c>();
                            List<Time_Record__c> lstTimeRecordsToUpdate = New List <Time_Record__c>();
                            for(Time_Record__c objTr: tsWeek.Time_Records__r)
                            {
                                integer index = 0;
                                if(mpToDelete.get(objTr.Id) == null)
                                {
                                    for(Time_Record__c objTrDup: tsWeek.Time_Records__r)
                                    {
                                        if(objTrDup != objTr && objTrDup.Week__c == objTr.Week__c &&
                                           objTrDup.Date__c == objTr.Date__c &&
                                           objTrDup.IT_Portfolio_Management__c == objTr.IT_Portfolio_Management__c &&
                                           objTrDup.Activity_Type__c == objTr.Activity_Type__c &&
                                           objTrDup.Activity_Sub_Type__c == objTr.Activity_Sub_Type__c &&
                                           objTrDup.System__c == objTr.System__c &&
                                           objTrDup.Stage__c == objTr.Stage__c &&
                                           objTrDup.Cost_Center__c   == objTr.Cost_Center__c     &&
                                           objTrDup.Work_Hours__c == objTr.Work_Hours__c &&
                                           objTrDup.Work__c == objTr.Work__c &&
                                           objTrDup.Task__c == objTr.Task__c)
                                        {
                                            objTr.Hours__c += objTrDup.Hours__c;
                                            lstTimeRecordsToUpdate.add(objTr);
                                            if(mpToDelete.get(objTrDup.Id) == null)
                                            {
                                                mpToDelete.put(objTrDup.Id, objTrDup);
                                            }
                                        }
                                    }
                                }
                                //delete mpToDelete;
                                System.debug('Query to Run for variable forLoop 261 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());
                                
                            }
                            If(lstTimeRecordstoUpdate.size() > 0){
                                System.debug('Number of records to Upsert: ' +lstTimeRecordstoUpdate.size());
                                upsert lstTimeRecordsToUpdate;    
                            }
                            

                            for (Id key : mpToDelete.keySet()) {
                                delete mpToDelete.get(key);
                            }
                            List<Timesheet_Week__c> weekSAfterDupCheck = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                                                                                                      Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c,
                                                                                                      (Select id, Week__c, Name, Date__c, Activity_Sub_Type__c, Activity_Type__c, Cost_Center__c, Hours__c, Stage__c, Project_Task__c, IT_Portfolio_Management__c, System__c, Work_Hours__c, Work__c, Task__c from Time_Records__r WHERE NOT IT_Portfolio_Management__c = '' order by IT_Portfolio_Management__r.Name ASC)
                                                                                                      FROM Timesheet_Week__c where Week_Start_Date__c =:weekStartDate
                                                                                                      and Week_End_Date__c =:WeekEndDate and User__c=:UserInfo.getUserId() limit 1]);
                            System.debug('Query to Run for variable Query for WeeksAfterDupCheck 273 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());

                            if(!weekSAfterDupCheck.isEmpty()) {
                                tsWeek = weekSAfterDupCheck[0];
                            }
                        }
                    }                    
                    catch (Exception e)
                    {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                    //Code Ends
                    
                    for(Time_Record__c tr: tsWeek.Time_Records__r) { 
                        projectWrapper objProjectWrapper = null; 
                        i++;
                        system.debug('=====totalMaqweqwep==='+i);
                        system.debug('=====projectWrapperList==='+projectWrapperList);
                        for(projectWrapper oProjectWrapper: projectWrapperList) {
                            if(tr.system__c != null){
                            if(oProjectWrapper.projectId == tr.IT_Portfolio_Management__c &&
                               oProjectWrapper.ActivityType == tr.Activity_Type__c &&
                               oProjectWrapper.ActivitySubType == tr.Activity_Sub_Type__c &&
                               oProjectWrapper.Stage == tr.Stage__c &&
                               oProjectWrapper.Application == tr.System__c  &&
                               oProjectWrapper.CostCenter == tr.Cost_Center__c &&
                               oProjectWrapper.WorkHours == tr.Work_Hours__c &&
                               oProjectWrapper.userStory == tr.Work__c &&
                               oProjectWrapper.userStoryTask == tr.Task__c)
                            {
                                Map<Date, Time_Record__c> dateWiseTRMap = new Map<Date, Time_Record__c>();
                                dateWiseTRMap.put(tr.Date__c, tr); 
                                for(DateWrapper d : weekDates){
                                    
                                    if(d.weekDate == tr.Date__c)
                                    {
                                        oProjectWrapper.timeRecordmap.put(d.order, (d.weekDate != null && dateWiseTRMap != null 
                                                                                    && dateWiseTRMap.containsKey(d.weekDate))? dateWiseTRMap.get(d.weekDate): new Time_record__c(date__c = d.weekDate));
                                        oProjectWrapper.total += (oProjectWrapper.timeRecordmap.get(d.order).Hours__c  != null? oProjectWrapper.timeRecordmap.get(d.order).Hours__c : 0);
                                    }
                                    
                                }
                                objProjectWrapper = new projectWrapper(weekDates, projectWrapperList.size());
                            }
                            }
                        }
                        if(objProjectWrapper == null){
                            objProjectWrapper = new projectWrapper(weekDates, projectWrapperList.size());
                            objProjectWrapper.trObj = new Time_record__c(id = tr.Id, Date__c = tr.Date__c, Activity_Sub_Type__c = tr.Activity_Sub_Type__c, 
                                                                         Activity_Type__c = tr.Activity_Type__c, Cost_Center__c = tr.Cost_Center__c, Hours__c = tr.Hours__c, 
                                                                         Stage__c = tr.Stage__c, System__c = tr.System__c, Work_Hours__c = tr.Work_Hours__c, IT_Portfolio_Management__c = tr.IT_Portfolio_Management__c);
                            objProjectWrapper.projectId = tr.IT_Portfolio_Management__c;            
                            objProjectWrapper.Stage = tr.Stage__c;                            
                            objProjectWrapper.CostCenter = tr.Cost_Center__c;
                            objProjectWrapper.WorkHours = tr.Work_Hours__c;            
                            objProjectWrapper.timeRecordmap = new Map<Integer, Time_Record__c>();
                            objProjectWrapper.Application = tr.System__c;
                            
                            If(string.isNotEmpty(objProjectWrapper.projectId))
                            {
                                String Methodology = [Select Methodology__c from IT_Portfolio_Management__c where id = :objProjectWrapper.projectId limit 1].Methodology__c;
                                if (String.isNotEmpty(Methodology))
                                {                                
                                    objProjectWrapper.Methodology = Methodology;                                
                                    objProjectWrapper.ActivityType = tr.Activity_Type__c;                            
                                    objProjectWrapper.ActivityTypes = new List<SelectOption>();
                                    objProjectWrapper.ActivityTypes.add(new SelectOption('', '---Select---'));
                                    Map<String,List<String>> valueMapDependentOptions = getDependentOptions('IT_Portfolio_Management__c','Methodology__c','Activity_Type__c');
                                    for(String contr : valueMapDependentOptions.keySet())            
                                    {
                                        if(contr == objProjectWrapper.Methodology)
                                        {
                                            for(String optionValue : valueMapDependentOptions.get(contr))            
                                            {
                                                objProjectWrapper.ActivityTypes.add(new SelectOption(optionValue, optionValue));
                                            }                
                                        }
                                    }  
                                }
                            }
                            System.debug('Query to Run for variable ProjectWrapper 353 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());

                            objProjectWrapper.ActivitySubTypes = new List<SelectOption>();
                            objProjectWrapper.ActivitySubTypes.add(new SelectOption('', '---Select---'));
                            Map<String,List<String>> valueMap = getDependentOptions('IT_Portfolio_Management__c','Activity_Type__c','DT_Project_Type__c');
                            for(String contr : valueMap.keySet())            
                            {
                                if(contr == objProjectWrapper.ActivityType)
                                {
                                    for(String optionValue : valueMap.get(contr))            
                                    {
                                        objProjectWrapper.ActivitySubTypes.add(new SelectOption(optionValue, optionValue));
                                    }                
                                }
                            }              
                            objProjectWrapper.ActivitySubType = tr.Activity_Sub_Type__c;
                            
                            objProjectWrapper.Activities = new List<SelectOption>();
                            List<IT_Portfolio_Management__c> IntakeList = [SELECT Id, name, ITS_Application__c, Charge_Back_Cost_Center__c, Stage__C, DT_Project_Stage__c FROM IT_Portfolio_Management__c where DT_Project_Type__c = :objProjectWrapper.ActivitySubType and Activity_Type__c = :objProjectWrapper.ActivityType];
                            objProjectWrapper.Activities.add(new SelectOption('', '---Select---'));
                            for( IT_Portfolio_Management__c objIntake : IntakeList)
                            {
                                objProjectWrapper.Activities.add(new SelectOption(objIntake.Name, objIntake.Name));
                            }  
                            
                            List<IT_Portfolio_Management__c> objIntakeList = [SELECT Id, name FROM IT_Portfolio_Management__c where id = :objProjectWrapper.projectId];            
                            if (objIntakeList.size() == 1)
                            {
                                objProjectWrapper.Activity = objIntakeList[0].name;
                            }

                            if (linkAgileAcceleratorToTimesheet) { 
                                objProjectWrapper.userStory = tr.Work__c;
                                objProjectWrapper.userStories = getUserStoryOptions(objProjectWrapper.Activity, false);
                                objProjectWrapper.userStoryTask = tr.Task__c;
                                objProjectWrapper.userStoryTasks = getUserStoryTaskOptions(objProjectWrapper.userStory, false);
                                objProjectWrapper.tasksHoursRemainingMap = mSelectedUserStoryTasksMap;
                                objProjectWrapper.updateRemainingHours();
                            }                            
                            System.debug('Query to Run for variable linkAgileAcceleratorToTimesheet 392 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());

                            //Abhisheks Code (19 Dec 2016) to set System as default if not found in the list
                            boolean bSystemPresentInTheList = false;
                            for(SelectOption so : Applications)
                            {
                                if(objProjectWrapper.Application == so.getValue())
                                {
                                    bSystemPresentInTheList = true;
                                    break;
                                }
                            }
                            
                            if(!bSystemPresentInTheList)
                            {
                                objProjectWrapper.Application = SystemDefault;
                            }
                            //Abhishek Code Ends
                            
                            projectWrapperList.add(objProjectWrapper);
                            
                            //objProjectWrapper.timeRecordmap.put(1, tr); 
                            //objProjectWrapper.total += (objProjectWrapper.timeRecordmap.get(d.order).Hours__c  != null? objProjectWrapper.timeRecordmap.get(d.order).Hours__c : 0);
                            Map<Date, Time_Record__c> dateWiseTRMap = new Map<Date, Time_Record__c>();
                            dateWiseTRMap.put(tr.Date__c, tr); 
                            for(DateWrapper d : weekDates){
                                
                                objProjectWrapper.timeRecordmap.put(d.order, (d.weekDate != null && dateWiseTRMap != null 
                                                                              && dateWiseTRMap.containsKey(d.weekDate))? dateWiseTRMap.get(d.weekDate): new Time_record__c(date__c = d.weekDate));
                                objProjectWrapper.total += (objProjectWrapper.timeRecordmap.get(d.order).Hours__c  != null? objProjectWrapper.timeRecordmap.get(d.order).Hours__c : 0);
                            }
                        }
                        if(!tempMap.containsKey(tr.Date__c)){
                            tempMap.put(tr.Date__c, 0);    
                        }
                        tempMap.put(tr.Date__c, tempMap.get(tr.Date__c)+ (tr.Hours__c != null? tr.Hours__c : 0));
                        
                        //projectWrapperList.add(new projectWrapper(tr.IT_Portfolio_Management__c, weekDates, tr));
                    }
                }
            }else{
                //Code to prepare timesheet week, and add timesheet activities from the previously submitted week
                tsWeek.Status__c = 'Open';
                tsWeek.User__c = UserInfo.getUserId();
                tsWeek.Week_Start_Date__c =  weekStartDate;
                tsWeek.Week_End_Date__c =  WeekEndDate;
                isEditable = true;
                    Date tempstartdate =  weekStartDate.addDays(-1).toStartofWeek();
                    Date tempEnddate = tempstartdate.addDays(6);
                    system.debug('---tempstartdate---'+tempstartdate);
                    system.debug('---tempEnddate---'+tempEnddate);
                    List<Timesheet_Week__c> tempweekS = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                                                                                     Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c, LastModifiedDate,
                                                                                     (Select id, Name, Date__c, Activity_Sub_Type__c, Activity_Type__c, Cost_Center__c, Hours__c, Stage__c, Project_Task__c, IT_Portfolio_Management__c, System__c, Work_Hours__c, Work__c, Task__c from Time_Records__r WHERE NOT IT_Portfolio_Management__c = '' order by IT_Portfolio_Management__r.Name ASC)
                                                                                     FROM Timesheet_Week__c where User__c=:UserInfo.getUserId()
                                                                                     //and Week_Start_Date__c =:weekStartDate
                                                                                     //and Week_End_Date__c =:WeekEndDate 
                                                                                     Order By LastModifiedDate DESC
                                                                                     limit 1]);
                    
                    
                    if(!tempweekS.isEmpty() && !tempweekS[0].Time_Records__r.isEmpty()){
                        system.debug('---tempweek inSide loop---'+ tempweekS);
                        lastSavedOn = string.valueOf(tempweekS[0].Week_Start_Date__c) + ' - ' + string.valueOf(tempweekS[0].Week_End_Date__c);
                        for(Time_Record__c tr: tempweekS[0].Time_Records__r) {    
                            system.debug('---projectWrapperList inSide loop---'+projectWrapperList.size());
                            boolean bAddProject = true;
                            for(projectWrapper oProjectWrapper: projectWrapperList) {                
                                if(oProjectWrapper.projectId == tr.IT_Portfolio_Management__c &&                                   
                                   oProjectWrapper.ActivityType == tr.Activity_Type__c &&
                                   oProjectWrapper.ActivitySubType == tr.Activity_Sub_Type__c &&
                                   oProjectWrapper.Stage == tr.Stage__c &&
                                   (oProjectWrapper.Application == tr.System__c || tr.System__c.contains('INF')) &&
                                   oProjectWrapper.CostCenter == tr.Cost_Center__c &&
                                   oProjectWrapper.WorkHours == tr.Work_Hours__c &&
                                   oProjectWrapper.userStory == tr.Work__c &&
                                   oProjectWrapper.userStoryTask == tr.Task__c)
                                {
                                    bAddProject = false;
                                }
                            }
                            if(bAddProject)   {
                                system.debug('---Adding Project---'+bAddProject);
                                projectWrapper objProjectWrapper = new projectWrapper(weekDates, projectWrapperList.size());
                                
                                objProjectWrapper = new projectWrapper(weekDates, projectWrapperList.size());
                                objProjectWrapper.trObj = new Time_record__c(Date__c = tr.Date__c, Activity_Sub_Type__c = tr.Activity_Sub_Type__c, 
                                                                             Activity_Type__c = tr.Activity_Type__c, Cost_Center__c = tr.Cost_Center__c, Hours__c = tr.Hours__c, 
                                                                             Stage__c = tr.Stage__c, System__c = tr.System__c, Work_Hours__c = tr.Work_Hours__c, IT_Portfolio_Management__c = tr.IT_Portfolio_Management__c);
                                objProjectWrapper.projectId = tr.IT_Portfolio_Management__c;            
                                objProjectWrapper.Stage = tr.Stage__c;
                                objProjectWrapper.CostCenter = tr.Cost_Center__c;
                                objProjectWrapper.WorkHours = tr.Work_Hours__c;            
                                objProjectWrapper.timeRecordmap = new Map<Integer, Time_Record__c>();
                                objProjectWrapper.Application = tr.System__c;
                                                                
                                If(string.isNotEmpty(objProjectWrapper.projectId))
                                {
                                    String Methodology = [Select Methodology__c from IT_Portfolio_Management__c where id = :objProjectWrapper.projectId limit 1].Methodology__c;
                                    if (String.isNotEmpty(Methodology))
                                    {                                
                                        objProjectWrapper.Methodology = Methodology;                                
                                        objProjectWrapper.ActivityType = tr.Activity_Type__c;                            
                                        objProjectWrapper.ActivityTypes = new List<SelectOption>();
                                        objProjectWrapper.ActivityTypes.add(new SelectOption('', '---Select---'));
                                        Map<String,List<String>> valueMapDependentOptions = getDependentOptions('IT_Portfolio_Management__c','Methodology__c','Activity_Type__c');
                                        for(String contr : valueMapDependentOptions.keySet())            
                                        {
                                            if(contr == objProjectWrapper.Methodology)
                                            {
                                                for(String optionValue : valueMapDependentOptions.get(contr))            
                                                {
                                                    objProjectWrapper.ActivityTypes.add(new SelectOption(optionValue, optionValue));
                                                }                
                                            }
                                        }  
                                    }
                                }
                                
                                objProjectWrapper.ActivitySubTypes = new List<SelectOption>();
                                objProjectWrapper.ActivitySubTypes.add(new SelectOption('', '---Select---'));
                                Map<String,List<String>> valueMap = getDependentOptions('IT_Portfolio_Management__c','Activity_Type__c','DT_Project_Type__c');
                                for(String contr : valueMap.keySet())            
                                {
                                    if(contr == objProjectWrapper.ActivityType)
                                    {
                                        for(String optionValue : valueMap.get(contr))            
                                        {
                                            objProjectWrapper.ActivitySubTypes.add(new SelectOption(optionValue, optionValue));
                                        }                
                                    }
                                }              
                                objProjectWrapper.ActivitySubType = tr.Activity_Sub_Type__c;
                                
                                objProjectWrapper.Activities = new List<SelectOption>();
                                List<IT_Portfolio_Management__c> IntakeList = [SELECT Id, name, ITS_Application__c, Charge_Back_Cost_Center__c, Stage__C, DT_Project_Stage__c FROM IT_Portfolio_Management__c where DT_Project_Type__c = :objProjectWrapper.ActivitySubType and Activity_Type__c = :objProjectWrapper.ActivityType];
                                objProjectWrapper.Activities.add(new SelectOption('', '---Select---'));
                                for( IT_Portfolio_Management__c objIntake : IntakeList)
                                {
                                    objProjectWrapper.Activities.add(new SelectOption(objIntake.Name, objIntake.Name));
                                }  
                                
                                List<IT_Portfolio_Management__c> objIntakeList = [SELECT Id, name FROM IT_Portfolio_Management__c where id = :objProjectWrapper.projectId];            
                                if (objIntakeList.size() == 1)
                                {
                                    objProjectWrapper.Activity = objIntakeList[0].name;
                                }

                                if (linkAgileAcceleratorToTimesheet) { 
                                    objProjectWrapper.userStory = tr.Work__c;
                                    objProjectWrapper.userStories = getUserStoryOptions(objProjectWrapper.Activity, false);
                                    objProjectWrapper.userStoryTask = tr.Task__c;
                                    objProjectWrapper.userStoryTasks = getUserStoryTaskOptions(objProjectWrapper.userStory, false);
                                    objProjectWrapper.tasksHoursRemainingMap = mSelectedUserStoryTasksMap;
                                    objProjectWrapper.updateRemainingHours();
                                }      
                                
                                for(DateWrapper d : weekDates){
                                    
                                    objProjectWrapper.timeRecordmap.put(d.order, new Time_record__c(date__c = d.weekDate));
                                    objProjectWrapper.total = 0;
                                }
                                
                                //Abhisheks Code (19 Dec 2016) to set System as default if not found in the list
                                boolean bSystemPresentInTheList = false;
                                for(SelectOption so : Applications)
                                {
                                    if(objProjectWrapper.Application == so.getValue())
                                    {
                                        bSystemPresentInTheList = true;
                                        break;
                                    }
                                }
                                
                                if(!bSystemPresentInTheList)
                                {
                                    objProjectWrapper.Application = SystemDefault;
                                }
                                //Abhishek Code Ends
                                
                                projectWrapperList.add(objProjectWrapper);
                            }    
                        }   
                    }
                //}
            }
            
            grandTotal = 0;
            for(DateWrapper d : weekDates){
                if(!totalMap.containsKey(d.order)){
                    totalMap.put(d.order, 0) ;       
                }
                if(tempMap.containsKey(d.weekdate)){
                    totalMap.put(d.order,tempMap.get(d.weekdate)) ;     
                }
                grandTotal += totalMap.get(d.order);
            }
            
        }
        if(projectWrapperList.isEmpty()){
            addRow();    
        }
        System.debug('Query to Run for variable getting new Timesheetweek 594 Run | CPU Time : ' + Limits.getCpuTime() + ' of ' + Limits.getLimitCpuTime());

    }

    /* 
     * Go to next Week 
     */
    public pagereference gotoNextWeek(){
        if(weekStartDate !=null){
            weekStartDate = weekStartDate.addDays(7);
            weekEndDate = weekStartDate.addDays(6);
            /*if(WeekstartDate == Date.today().toStartofWeek()){
                isCurretWeek = true;    
            }*/
            findWeek(false);
        } 
        return null;
    }

    /* 
     * Go to Previous week
     */
    public pagereference gotoPreviousWeek(){
        if(weekStartDate == null){
            weekStartDate = Date.today().toStartofWeek();
        }
        
        weekStartDate = weekStartDate.addDays(-1).toStartofWeek();
        
        weekEndDate = weekStartDate.addDays(6);
        isCurretWeek = false;
        findWeek(false);
        return null;
    }

    /* 
     * For selecting current week
     */
    public pagereference goToCurrentWeek(){
        weekStartDate = Date.today().toStartofWeek();  
        weekEndDate = weekStartDate.addDays(6);
        //isCurretWeek = true;
        findWeek(false);
        return null;
    }

    /*
     * Make Date list for showing on vf page (table Header)
     */
    public void  makeDateList(){
        weekDates = new List<DateWrapper>();
        for(Integer i=0; i<7;i++){
            Date d = weekStartDate.addDays(i);
            weekDates.add(new DateWrapper(d,weekDates.size()));
        }
    }

    /* 
     * Save only method
     */
    public pageReference doSave(){
        isSubmit = false;
        if (save())
        {
            findWeek(false);
        }
        return null;
    }
    
    /* 
     * It calculate hours whenveruser enters value in table and tabout
     */
    public void calculateTotalHours(){
        totalMap = new Map<integer, decimal>();
        Map<Date,decimal> tempMap = new Map<Date,decimal>();
        if(!projectWrapperList.isEmpty()){
            grandTotal = 0;
            for(projectWrapper pw : projectWrapperList){
                Decimal total = 0;
                if(!pw.timeRecordmap.isEmpty()){
                    for(Time_Record__c tr: pw.timeRecordmap.values()){
                        total += tr.Hours__c != null? tr.Hours__c: 0;           
                        if(!tempMap.containsKey(tr.Date__c)){
                            tempMap.put(tr.Date__c, 0);    
                        }
                        tempMap.put(tr.Date__c, tempMap.get(tr.Date__c)+ (tr.Hours__c != null? tr.Hours__c : 0));
                    }
                    pw.total= total;
                }    
            }
        } 
        for(DateWrapper d : weekDates){
            if(!totalMap.containsKey(d.order)){
                totalMap.put(d.order, 0) ;       
            }
            if(tempMap.containsKey(d.weekdate)){
                totalMap.put(d.order,tempMap.get(d.weekdate)) ;     
            }
            grandTotal += totalMap.get(d.order);
        }
    }
    
    /*
     *
     */
    public boolean save(){
        
        if(isEditable){
            calculateTotalHours();
            
            if(grandTotal < 40 && isSubmit){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,label.TS_HoursLimitErrorMsg));
                return false;
            } 
            if(!projectWrapperList.isEmpty()){
                boolean projError = false;
                //Start Sanjay Singh 11/23/2016 
                Set<Id> actSet = new Set<Id>();
                Map<Id, IT_Portfolio_Management__c> actMap = new Map<Id, IT_Portfolio_Management__c>();
                for(projectWrapper p : projectWrapperList){
                    if(p.trObj.IT_Portfolio_Management__c != null){
                        actSet.add(p.trObj.IT_Portfolio_Management__c);
                    }
                }
                actMap = new Map<Id, IT_Portfolio_Management__c>([Select id, Name,RecordTypeId,RecordType.DeveloperName from IT_Portfolio_Management__c where id in :actSet]);
                List <id> PMLifecycleIDs = new list<id>();
                for(projectWrapper p : projectWrapperList){ 
                    PMLifecycleIDs.add(p.trObj.IT_Portfolio_Management__c);
                    System.debug('p-->'+p);
                    //System.debug('p.Application==>'+p.Application);
                    //System.debug('RecordType.DeveloperName--'+actMap.get(p.trObj.IT_Portfolio_Management__c).RecordType.DeveloperName);
                    if(p.trObj.IT_Portfolio_Management__c == null ){// Removed extra condition || string.isEmpty(p.Activity)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select a Project for - ' + p.ActivityType)); 
                    projError = true;   
                    }
                   /* else if(p.trObj.IT_Portfolio_Management__r.Project_Status__c != 'In-Progress') {// Removed extra condition || string.isEmpty(p.Activity)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select a different project. This project is no longer in progress for - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                        projError = true;   
                    }*/
                    else if(p.ActivityType == null || p.ActivitySubType == null){// Removed extra condition || string.isEmpty(p.Activity)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select a Phase and Sub Phase for - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                        projError = true;   
                    }
                    else if(actMap.get(p.trObj.IT_Portfolio_Management__c).RecordType.DeveloperName == 'Enhancement'){
                        if(p.Application == null || p.Application == '' || String.isBlank(p.Application)){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select a Specialty Area for - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                            projError = true; 
                        }  
                    }
                 
                        
                    else if(string.isEmpty(p.Application) || p.Application == '----------' ){                                  
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,
                                                                    'Please select a Sub-Specialty for - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name + '. Select N/A if it is a non-ConnectHope Project.')); 
                        projError = true;   
                    }
                     else if(p.trObj.IT_Portfolio_Management__c == 'aAK0V000001tU6yWAE')
                     {                                  
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,
                                                                    'Please select ADM-Admnistrator instead of T&A-Time Away from Work under Project Column.')); 
                        //p.trObj.IT_Portfolio_Management__c.addError('');
                        projError = true;   
                    }
                    /*else if(string.isEmpty(p.Application) || p.Application == '----------' ){    
                        //|| string.isEmpty(p.CostCenter) || string.isEmpty(p.WorkHours)){                                
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,
                                                                    'Please select System/Infrastructure for - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                        //p.trObj.IT_Portfolio_Management__c.addError('');
                        projError = true;   
                    }*/
                    //End Sanjay Singh 11/23/2016
                    else if(weekStartDate > Date.today().toStartofWeek().addDays(6) && p.ActivityType != 'Time Away from Work'){                                
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Future time entries are only allowed for Time Away from Work')); 
                        projError = true;   
                    }
                    else if(linkAgileAcceleratorToTimesheet) {
                        if (p.userStory == INVALID_INPUT_VALUE) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You Must Select a User Story - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                            projError = true;  
                        }   
                        else if (p.userStoryTask == INVALID_INPUT_VALUE) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'You Must Select a Task - ' + actMap.get(p.trObj.IT_Portfolio_Management__c).Name)); 
                            projError = true;  
                        }                     
                    }
                }
               List <IT_Portfolio_Management__c> PMLifeCyclesnotInProgress = [select id, name, project_status__c from IT_Portfolio_Management__c where id in: PMLifecycleIDs and 
                                                                              (project_status__c != 'In-Progress' and //Larry adding additional conditions to show projects to submit time to.
                                                                               project_status__c != 'Complete')
                                                                               ];
                if(PMLifeCyclesnotInProgress.size() > 0){
                    for(IT_Portfolio_Management__c pmLifeCycleRecords : PMLifeCyclesnotInProgress) {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, pmLifeCycleRecords.name +' is no longer in "In-Progress, or Complete" status, its current status is '+ '"'+pmLifeCycleRecords.project_status__c+'" you may not submit time for this project.' ));
    	                projError = true;                                 
                    }
               }
                
                if(projError){
                    return false;
                }
                
                
                try{
                    if(isSubmit){
                        tsWeek.Status__c = 'Submitted';    
                        List<User> lstUser = [Select Id, Name, Department, Supervisor__c from User where id = :UserInfo.getUserId() limit 1];
                        if(lstUser.size() > 0)
                        {
                            List<PeopleSoft__c> lstPeopleSoft = [Select Name, ITLT_Owner__c, ITLT_Owner__r.Name from PeopleSoft__c where name = :lstUser[0].Department Limit 1];
                            if(lstPeopleSoft.size() > 0)
                            {
                                tsWeek.ITLT_Owner__c = lstPeopleSoft[0].ITLT_Owner__r.Name; 
                                tsWeek.User_Department__c = lstUser[0].Department; 
                                tsWeek.User_Supervisor__c = lstUser[0].Supervisor__c; 
                            } 
                        }                                                   
                    }
                    upsert tsWeek;
                    if(isSubmit){
                        if(checkUserAccess()){
                            isEditable = true;
                        }else{
                            isEditable = false;
                        }
                    }else{
                        isEditable = true;
                    }
                    List<Time_Record__c> trToupsert = new List<Time_Record__c>();
                    List<Time_Record__c> trToDelete = new List<Time_Record__c>();
                    /*** Changes Made by Sanjay Date 12-06-2016 :::: Start******/
                    
                    /*Set<id> tmIds = new Set<id>();
                    for(projectWrapper pw : projectWrapperList){
                        if(pw.trObj != null && pw.trObj.IT_Portfolio_Management__c  != null &&  !pw.timeRecordmap.isEmpty()){
                            
                            for(DateWrapper dr : weekDates){
                                if(dr.order != null && dr.weekDate != null && pw.timeRecordmap.containsKey(dr.order)){
                                    Time_Record__c tr =  pw.timeRecordmap.get(dr.order);
                                    if(tr.id != null)
                                        tmIds.add(tr.id);
                                }
                            }
                        }
                    }
                    Map<Id, Time_Record__c> trMap = new Map<Id, Time_Record__c>([select id, Name from Time_Record__c where id in: tmIds]);*/
                    /*** Changes Made by Sanjay Date 12-06-2016 :::: End******/
                    
                    Decimal totalHours = 0;
                    List<integer> listPWToRemove = new List<integer>();
                    //Map<integer, integer> mapPWToRemove = new Map<integer, integer>();
                    for(projectWrapper pw : projectWrapperList){
                        if(pw.trObj != null && pw.trObj.IT_Portfolio_Management__c  != null &&  !pw.timeRecordmap.isEmpty()){
                            
                            for(DateWrapper dr : weekDates){
                                if(dr.order != null && dr.weekDate != null && pw.timeRecordmap.containsKey(dr.order)){
                                    Time_Record__c tr =  pw.timeRecordmap.get(dr.order);
                                    tr.date__c = dr.weekDate;
                                    tr.IT_Portfolio_Management__c = pw.trObj.IT_Portfolio_Management__c ;
                                    if (!String.isEmpty(pw.ActivityType))
                                    {
                                        tr.Activity_Type__c = pw.ActivityType;                                        
                                    }
                                    if (!String.isEmpty(pw.ActivitySubType))
                                    {
                                        tr.Activity_Sub_Type__c = pw.ActivitySubType;                                        
                                    }
                                    if (!String.isEmpty(pw.Application))
                                    {
                                        tr.System__c = pw.Application;                                        
                                    }
                                    if (!String.isEmpty(pw.WorkHours))
                                    {
                                        tr.Work_Hours__c = pw.WorkHours;                                        
                                    }
                                    if (!String.isEmpty(pw.Stage))
                                    {
                                        tr.Stage__c = pw.Stage ;                                        
                                    }
                                    if (!String.isEmpty(pw.CostCenter))
                                    {
                                        tr.Cost_Center__c = pw.CostCenter ;                                        
                                    }
                                    if(pw.ptObj != null)
                                    {
                                        tr.Project_Task__c =  pw.ptObj.id ;
                                    }
                                    if(tr.Week__c == null)
                                    {
                                        tr.Week__c = tsWeek.id;
                                    }
                                    if((tr.Hours__c == null || tr.Hours__c== 0) && tr.id != null){
                                        trToDelete.add(tr) ; 
                                    }
                                    // If the user links Agile Accelerator to the ITS Timesheet, save userStory and userStoryTask       
                                    // They are allowed to be null.                             
                                    if (linkAgileAcceleratorToTimesheet) {
                                        tr.Work__c = pw.userStory;
                                        tr.Task__c = pw.userStoryTask;
                                    }


                                    /*** Changes Made by Sanjay Date 12-06-2016 :::: Start******/
                    
                                    /*if((tr.Hours__c == null || tr.Hours__c== 0) && tr.id != null && trMap.containsKey(tr.id)){
                                        
                                        system.debug('==========='+tr);
                                        trToDelete.add(tr) ;
                                        pw.timeRecordmap.put(dr.order, new Time_Record__c(Date__c = dr.weekDate));
                                    }*/
                                    /*** Changes Made by Sanjay Date 12-06-2016 :::: End******/
                    
                                    if(tr.Hours__c > 0){
                                        trToupsert.add(tr);   
                                    }
                                }
                            }
                        }
                    } 
                    
                    /*for(Integer key : mapPWToRemove.keySet())
                    {
                        projectWrapperList.remove(mapPWToRemove.get(key));
                    }*/
                    
                    if(!trToupsert.isEmpty()){
                        upsert trToupsert;  
                    }
                    if(!trToDelete.isEmpty()){
                        Delete trToDelete;
                    }


                    
                    system.debug('====grandTotal ====='+grandTotal );
                    
                    if(isSubmit){
                        if(grandTotal >40 ){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning,'Total hours are greater than 40.'));   
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Data Successfully stored.')); 
                        }else{            
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Time Records Submitted Successfully.'));      
                            //findWeek();
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Time Records Saved Successfully.'));      
                        //findWeek();
                    }    
                }Catch(Exception e){
                    apexpages.addMessages(e);                
                }    
            }
        }
        System.debug('Save method Complete 946 | CPU Time: ' + Limits.getCpuTime()  + ' of ' + Limits.getLimitCpuTime());
        
        return true;
        
    }
    
    /* 
     * Save and submit method 
     * Once the user submitted the week timesheet , he/she won't be able to update it later.                           
     */
    public pagereference doSubmit(){
        if(grandTotal > 100){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There should not be more than 100 hours for weekly timesheet.'));
            //  return;
            //   
            //removed the conidtion 
        }  
        else{
            
            isSubmit = true;
            if (save())
            {
                findWeek(false);
            }
        }
        return null;
    }
    
    /* 
     * To remove project row
     */
    public pageReference removeRow(){
        if(projectRoworder!= null && !projectWrapperList.isEmpty()){
            ProjectWrapper pr = projectWrapperList[projectRoworder];
            if(!pr.timeRecordmap.isEmpty()){
                list<Time_Record__c> timeRecToDelete = new list<Time_Record__c>();
                for(Time_Record__c tr: pr.timeRecordmap.values()){
                    if(tr != null && tr.id!= null){
                        timeRecToDelete.add(tr);    
                    }
                }
                try{
                    projectWrapperList.remove(projectRoworder);
                    if(!timeRecToDelete.isEmpty()){
                        delete timeRecToDelete;
                    }
                    integer ord=0;
                    for(ProjectWrapper p : projectWrapperList){
                        p.roworder = ord;
                        ord++;
                    }
                    //findWeek();
                }catch(Exception e){
                    apexpages.addMessages(e);
                }
            }
            
            
        }
        return null; 
    }
    
    /* 
     * Add row if new project
     */
    public pageReference addRow(){
        System.debug('Project Wrapper List Size: ' + projectWrapperList.size());
        if(projectWrapperList.size()> 0){
            projectWrapperList.add(0, new projectWrapper(weekDates, projectWrapperList.size()));
            integer i = 0;
            for(projectWrapper p : projectWrapperList){
                p.rowOrder= i;
                i++;
            }
        }    
        else
            projectWrapperList.add(new projectWrapper(weekDates, projectWrapperList.size()));
        return null;
    }
    
    /* 
     * Fetch activity Subtypes
     */
    public pageReference getActivitySubTypes(){
        string strRoworder = Apexpages.currentPage().getParameters().get('RowOrder');
        System.debug('getActivitySubTypes --> ');
        for (projectWrapper objProject : projectWrapperList)
        {
            if (objProject.rowOrder == integer.valueof(strRoworder))
            {
                objProject.ActivitySubTypes = new List<SelectOption>();
                objProject.ActivitySubTypes.add(new SelectOption('', '---Select---'));
                Map<String,List<String>> valueMap = getDependentOptions('IT_Portfolio_Management__c','Activity_Type__c','DT_Project_Type__c');
                for(String contr : valueMap.keySet())            
                {
                    if(contr == objProject.ActivityType)
                    {
                        for(String optionValue : valueMap.get(contr))            
                        {
                            objProject.ActivitySubTypes.add(new SelectOption(optionValue, optionValue));
                        }                
                    }
                }  
                
                /*objProject.Activity = '';
                objProject.Activities = new List<SelectOption>();
                objProject.Application = '';
                objProject.Stage = '';
                objProject.CostCenter = '';
                objProject.WorkHours = 'Reg Hours';*/                 
            }
        }
        
        return null;
    }   
    
    /*
     *
     */    
    public pageReference getActivityDependents(){
        string strRoworder = Apexpages.currentPage().getParameters().get('RowOrder');
        System.debug('strRoworder --> ' + strRoworder);
        for (projectWrapper objProject : projectWrapperList)
        {
            System.debug('objProject.rowOrder --> ' + objProject.rowOrder);
            if (objProject.rowOrder == integer.valueof(strRoworder))
            {
                List<IT_Portfolio_Management__c> IntakeList = [SELECT Id, name, ITS_Application__c, Activity_Type__c, Methodology__c, DT_Project_Type__c, Charge_Back_Cost_Center__c, Stage__C, DT_Project_Stage__c FROM IT_Portfolio_Management__c where Id = :objProject.trObj.IT_Portfolio_Management__c limit 1];
                System.debug('objProject.rowOrder --> ' + objProject.rowOrder);
                if (IntakeList != null && IntakeList.size() == 1) // && !string.isEmpty(objProject.Activity)
                {
                    System.debug('IntakeList[0].ITS_Application__c --> ' + IntakeList[0].ITS_Application__c);
                    if(!string.isEmpty(IntakeList[0].ITS_Application__c))
                    {
                        objProject.Application = IntakeList[0].ITS_Application__c;
                    }
                    if(!string.isEmpty(IntakeList[0].Charge_Back_Cost_Center__c))
                    {
                        objProject.CostCenter = IntakeList[0].Charge_Back_Cost_Center__c;
                        objProject.bDisableCustomerDept = true;
                    }                    
                    else
                    {
                        objProject.bDisableCustomerDept = false;
                    }
                    if(!string.isEmpty(IntakeList[0].Methodology__c) && IntakeList[0].Methodology__c=='Enhancement'){
                        objProject.isDisabledSpecialityArea = true;
                    }
                    else{
                       objProject.isDisabledSpecialityArea = false; 
                    }
                    //isDisabledSpecialityArea
                    if(!string.isEmpty(IntakeList[0].Name))
                    {
                        objProject.Activity = IntakeList[0].Name;
                    }
                    
                    if(!string.isEmpty(IntakeList[0].Methodology__c))
                    {
                        objProject.Methodology = IntakeList[0].Methodology__c;
                        objProject.ActivityTypes = new List<SelectOption>();
                        objProject.ActivityTypes.add(new SelectOption('', '---Select---'));
                        Map<String,List<String>> valueMap = getDependentOptions('IT_Portfolio_Management__c','Methodology__c','Activity_Type__c');
                        for(String contr : valueMap.keySet())            
                        {
                            if(contr == objProject.Methodology)
                            {
                                for(String optionValue : valueMap.get(contr))            
                                {
                                    objProject.ActivityTypes.add(new SelectOption(optionValue, optionValue));
                                }                
                            }
                        }  
                    }
                    
                    if(!string.isEmpty(IntakeList[0].Activity_Type__c))
                    {
                        objProject.ActivityType = IntakeList[0].Activity_Type__c;
                        
                        System.debug('objProject.ActivityType --> ' + objProject.ActivityType);
                        
                        //getActivitySubTypes();                        
                        objProject.ActivitySubTypes = new List<SelectOption>();
                        objProject.ActivitySubTypes.add(new SelectOption('', '---Select---'));
                        Map<String,List<String>> valueMap = getDependentOptions('IT_Portfolio_Management__c','Activity_Type__c','DT_Project_Type__c');
                        for(String contr : valueMap.keySet())            
                        {
                            if(contr == objProject.ActivityType)
                            {
                                for(String optionValue : valueMap.get(contr))            
                                {
                                    objProject.ActivitySubTypes.add(new SelectOption(optionValue, optionValue));
                                }                
                            }
                        }  
                        
                        if(!string.isEmpty(IntakeList[0].DT_Project_Type__c))
                        {
                            objProject.ActivitySubType = IntakeList[0].DT_Project_Type__c;
                            
                            System.debug('objProject.ActivitySubType --> ' + objProject.ActivitySubType);
                        }
                        else
                        {
                            objProject.ActivitySubType = '';
                        }
                        
                        if(!string.isEmpty(IntakeList[0].DT_Project_Stage__c))
                        {
                            objProject.Stage = IntakeList[0].DT_Project_Stage__c;
                        }
                        else if(objProject.ActivityType == 'Customer Service' || objProject.ActivityType == 'Administration'
                                || objProject.ActivityType == 'Change Management')
                        {
                            objProject.Stage = 'N/A';
                        }     
                        else
                        {
                            objProject.Stage = '';
                        }    
                    }
                    else
                    {
                        objProject.ActivityType = '';
                    }                   
                                       
                    //objProject.trObj.IT_Portfolio_Management__c =  IntakeList[0].Id;                
                }
            }
        }
        getUserStories();
        return null;
    }
    
    /*
     *
     */    
    public Map<String,List<String>> getDependentOptions(String objName, String contrfieldName, String depfieldName){
        
        String objectName = objName.toLowerCase();
        String controllingField = contrfieldName.toLowerCase();
        String dependentField = depfieldName.toLowerCase();        
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
        }
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
            Schema.PicklistEntry depentry = depEntries[dependentIndex];
            objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries){
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
        }
        objEntries = null;
        objJsonEntries = null;
        return objResults;
    }

    /* 
     * Loads the User Stories from Agile Acelerator for the selected Activity (Epic in Agile Accelerator)
     * Only loads the User stories if the current user has the Link_Agile_Accelerator_To_Timesheet__c checkbox checked.
     */
    public pageReference getUserStories() {
        // If User links Agile Accelerator and ITS Timesheet
        if (linkAgileAcceleratorToTimesheet) {
            // User row order to find the correct Project Wrapper
            string strRoworder = Apexpages.currentPage().getParameters().get('RowOrder');
            System.debug(strRoworder);
            for (projectWrapper objProject : projectWrapperList) {
                if (objProject.rowOrder == integer.valueof(strRoworder)) {
                    // Reset the values in the Project Wrapper
                    String ITSActivityPortfolioName = [SELECT id, name FROM IT_Portfolio_Management__c WHERE id =: objProject.trObj.IT_Portfolio_Management__c].Name;
                   
                    objProject.userStory = null;
                    objProject.userStories = getUserStoryOptions(ITSActivityPortfolioName, true);
                    
                    
                    // If the Selected 'Activity' does not have an associated 'Epic', then the user story tasks select list should display N/A as well.
                    if (objProject.userStories.get(0).getValue() == '') {
                        objProject.userStoryTasks = new List<SelectOption>();
                        objProject.userStoryTasks.add(new SelectOption('','N/A'));
                    }
                    else {
                        objProject.userStoryTasks = null;
                    }
                    objProject.userStoryTask = null;
                }
            }
        }
        return null;
    }

    /* 
     * Loads the User Stories from Agile Acelerator for the selected Activity (Epic in Agile Accelerator)
     * Only loads the User stories if the current user has the Link_Agile_Accelerator_To_Timesheet__c checkbox checked.
     */
    public pageReference getUserStoryTasks() {
        // If User links Agile Accelerator and ITS Timesheet
        if (linkAgileAcceleratorToTimesheet) {
            // Use row order to find the correct project wrapper
            string strRoworder = Apexpages.currentPage().getParameters().get('RowOrder');
            for (projectWrapper objProject : projectWrapperList) { 
                if (objProject.rowOrder == integer.valueof(strRoworder)) {
                    // Reset the values in project wrapper
                    objProject.userStoryTask = null;
                    objProject.userStoryTasks = getUserStoryTaskOptions(objProject.userStory, true);
                    objProject.tasksHoursRemainingMap = mSelectedUserStoryTasksMap;
                }
            }
        }
        return null;
    }

    /*
     *
     */
    public pageReference getRemainingHours() {
        // If User links Agile Accelerator and ITS Timesheet
        if (linkAgileAcceleratorToTimesheet) {
            // Use row order to find the correct project wrapper
            string strRoworder = Apexpages.currentPage().getParameters().get('RowOrder');
            for (projectWrapper objProject : projectWrapperList) { 
                if (objProject.rowOrder == integer.valueof(strRoworder)) {
                    if (objProject.userStoryTask != null) {
                        objProject.updateRemainingHours();                    
                    }
                }
            }
        }
        return null;
    }     


    //------------------------------------- Private Functions -------------------------------------//



    /*
     * Builds and returns a List<SelectOption> of Agile Accelerator Tasks related to a specific user story (refered to in Agile Accelerator as Work). 
     *
     * @param agileAcceleratorWorkId                    The Record Id of the Agile Accelerator User Story whose Tasks are to be put into the List<SelectOption>
     * 
     * @param boolean includeSelect                     If true the populated List<SelectOption> will include the ---Select--- option. Otherwise it will not.     
     *
     * Returns                                          The List<SelectOption> populated with the Tasks associated with the Work whose Record Id was supplied as the parameter
     */
    private List<SelectOption> getUserStoryTaskOptions(string agileAcceleratorWorkId, boolean includeSelect) {
        List<SelectOption> taskSelectList = new List<SelectOption>();
        mSelectedUserStoryTasksMap = new Map<id, agf__ADM_Task__c>([SELECT id, Name, agf__Subject__c, agf__Work__r.id, agf__Starting_Hours__c, Timesheet_Remaining_Hours__c  FROM agf__ADM_Task__c WHERE agf__Work__r.id =: agileAcceleratorWorkId ORDER BY agf__Subject__c]);
        // If the User story has tasks, build the list
        if (mSelectedUserStoryTasksMap != null && (!(mSelectedUserStoryTasksMap.isEmpty()))) {
            List<agf__ADM_Task__c> selectedUserStoryTasksList = mSelectedUserStoryTasksMap.values();
            if (includeSelect) {
                taskSelectList.add(new SelectOption(INVALID_INPUT_VALUE, '---Select---'));
            }
            for (agf__ADM_Task__c userStoryTask : selectedUserStoryTasksList) {
                taskSelectList.add(new SelectOption(userStoryTask.Id, userStoryTask.agf__Subject__c));
            }
        }
        else {
            // If the User story does not have tasks, then the list should display N/A
            taskSelectList.add(new SelectOption('', 'N/A'));
        }
        return taskSelectList;
    }

    /*
     * Builds and returns a List<SelectOption> of Agile Accelerator User Stories (refered to in Agile Accelerator as Work) related 
     * to a specific Activity (refered to in Agile Accelerator as an Epic)
     *
     * @param string ITSActivityPortfolioName                   The name of the Agile Accelerator Epic whose related User Stories are to be put into the List<SelectOption>
     *                                                          The name of the Epic in Agile Accelerator and the ITSActivityPorfolioName must match exactly.
     * 
     * @param boolean includeSelect                             If true the populated List<SelectOption> will include the ---Select--- option. Otherwise it will not.
     *
     * Returns                                                  The List<SelectOption> populated with the User Stories associated with the Epic whose Name was supplied as the parameter
     */
    private List<SelectOption> getUserStoryOptions(string ITSActivityPortfolioName, boolean includeSelect) {
        setNumberOfDaysToShowUserStories();
        Date oldestValidDate = Date.today().addDays(mNumberOfDaysToShowUserStories);
        List<agf__ADM_Work__c> selectedEpicUserStories = new List<agf__ADM_Work__c>([
            SELECT id, Name, agf__Subject__c, agf__Epic__r.Name, agf__Sprint__r.agf__End_Date__c, agf__Sprint__r.agf__Start_Date__c
            FROM agf__ADM_Work__c 
            WHERE 
            	agf__Epic__r.Name =: ITSActivityPortfolioName AND
				agf__Sprint__r.agf__End_Date__c >: oldestValidDate AND
            	agf__Sprint__r.agf__Start_Date__c <=: Date.today()
        ]);
        //system.debug('saidaiah4'+selectedEpicUserStories);
        
        List<SelectOption> userStorySelectList = new List<SelectOption>();
        // If the selected Activity has an associated Epic, then build the select list       
        if (COHUtil.isValidList(selectedEpicUserStories)) {
            if (includeSelect) {
                userStorySelectList.add(new SelectOption(INVALID_INPUT_VALUE, '---Select---'));
            }
            userStorySelectList.add(new SelectOption('', 'N/A'));
            for (agf__ADM_Work__c userStory : selectedEpicUserStories) {
                
                userStorySelectList.add(new SelectOption(userStory.Id, userStory.agf__Subject__c));
            }
        }
        else {
            // If the selected Activity does NOT have an associated Epic, then the selected list should display N/A
            userStorySelectList.add(new SelectOption('', 'N/A'));
        }
        return userStorySelectList;
    }
    
    /*
     * Sets the global variable mNumberOfDaysToShowUserStories using a COH Configuration record.
     * If the necessary COH Configuration record does not exist, then mNumberOfDaysToShowUserStories is set to DEFAULT_NUMBER_OF_DAYS_TO_SHOW_USER_STORIES. 
     */ 
    private void setNumberOfDaysToShowUserStories() {
        Integer daysToShowUserStories = (Integer) COHUtil.getConfigurationValue('Timesheet', 'numberOfDaysToShowUserStories');
        if (daysToShowUserStories != null) {
            mNumberOfDaysToShowUserStories = daysToShowUserStories;
        }
        else {
            mNumberOfDaysToShowUserStories = DEFAULT_NUMBER_OF_DAYS_TO_SHOW_USER_STORIES;
        }
    }

    //------------------------------------- Sub Classes -------------------------------------//



    /* 
     * Inner class for binding date and day string 
     */
    public class DateWrapper{
        public date weekDate {get; set;}
        public string dateStr {get; set;}
        public string dayname {get; set;}
        public integer order  {get; set;}
        public DateWrapper(Date d, integer od){
            this.weekDate = d;
            if(od == null) 
                od = 0;
            this.order = od;
            if(d != null){
                this.dateStr = d.format() ;
                DateTime de = (DateTime)d;
                de = de.addHours(10);
                this.dayname = de.format('EEEE');      
            }else{
                this.dateStr = 'Date-'+ string.valueOf(od);
                this.dayname = 'Day-'+ string.valueOf(od);
            }
        }
    }
    
    /*
     *
     */    
    public class projectWrapper{
        public Time_Record__c trObj {get; set;}
        public map<Integer, Time_Record__c> timeRecordmap {get; set;}
        public string Methodology {get; set;}        
        public string ActivityType {get; set;}
        public List<SelectOption> ActivityTypes {get; set;}
        public string ActivitySubType {get; set;}
        public List<SelectOption> ActivitySubTypes {get; set;}
        public string Activity {get; set;}
        public List<SelectOption> Activities {get; set;}
        public Project_Task__c ptObj {get; set;}
        public List<SelectOption> projectTaskList {get; set;}
        public string Stage {get; set;}
        public string CostCenter {get; set;}
        public string WorkHours {get; set;}
        public id projectId {get; set;}
        public string Application {get; set;}
        public integer rowOrder {get; set;}
        public decimal total {get; set;}        
        public boolean bDisableCustomerDept {get; set;}
        // Added in order add User Stories and Tasks - TH
        public string userStory {get; set;}
        public List<SelectOption> userStories{get; set;}
        public string userStoryTask {get; set;}
        public List<SelectOption> userStoryTasks{get; set;}
        public decimal hoursRemaining {get; set;}
        public map<id, agf__ADM_Task__c> tasksHoursRemainingMap {get; set;}
        public boolean isDisabledSpecialityArea {get; set;}
        
        public projectWrapper(List<DateWrapper> dw, Integer ord){
            this.trObj = new Time_Record__c();
            this.timeRecordmap = new Map<Integer, Time_Record__c>();
            this.ptObj = new Project_Task__c();
            this.projectTaskList = new List<SelectOption>();
            this.rowOrder = ord ;
            this.total = 0;
            for(DateWrapper d : dw){
                timeRecordmap.put(d.order, new Time_Record__c(Date__c = d.weekDate));
            }
            
            //this.ActivityTypes = getActivityTypes();
        }        
        
        public projectWrapper(id projId, String strStage, String strTask, Map<date, Time_Record__c> dateWiseTRMap , List<DateWrapper> dw, Integer ord){
            this.trObj = new Time_record__c(IT_Portfolio_Management__c = projId);
            this.projectId = projId;
            this.timeRecordmap = new Map<Integer, Time_Record__c>();
            this.ptObj = new Project_Task__c();
            
            //Abhisheks code to bind project stage
            if (!String.isEmpty(strStage))
            {
                this.Stage = strStage;
            }
            
            this.rowOrder = ord;
            this.total = 0;
            for(DateWrapper d : dw){
                
                timeRecordmap.put(d.order, (d.weekDate != null && dateWiseTRMap != null 
                                            && dateWiseTRMap.containsKey(d.weekDate))? dateWiseTRMap.get(d.weekDate): new Time_record__c(date__c = d.weekDate));
                total += (timeRecordmap.get(d.order).Hours__c  != null? timeRecordmap.get(d.order).Hours__c : 0);
            }
        }
        
        public List<SelectOption> getActivityTypes()
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '---Select---'));
            Schema.DescribeFieldResult fieldResult = 
                IT_Portfolio_Management__c.Activity_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            return options;
        }

        /*
         *
         */
        public void updateRemainingHours() {
            if (userStoryTask != '-1'){
                if (tasksHoursRemainingMap != null) {
                    agf__ADM_Task__c selectedTask = tasksHoursRemainingMap.get(userStoryTask);
                    if (selectedTask != null) {
                        if (selectedTask.Timesheet_Remaining_Hours__c != null) {
                            hoursRemaining = selectedTask.Timesheet_Remaining_Hours__c;
                        }
                        else if (selectedTask.agf__Starting_Hours__c != null) {
                            hoursRemaining = selectedTask.agf__Starting_Hours__c;
                        }
                    }
                }                            
            }
            else {
                hoursRemaining = null;
            }
        }
    }
    
    /*
     * Class to interpret dependent picklists
     */
    public class BitSet{
        public Map<String,Integer> alphaNumCharCodes {get;set;}
        public Map<String, Integer> base64CharCodes {get;set;}
        
        public BitSet(){
            LoadCharCodes();
        }
        
        //Method loads the character codes for all letters
        private void LoadCharCodes(){
            alphaNumCharCodes = new Map<String,Integer>{
                'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
                    'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
                    'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90    
                    };
                        base64CharCodes = new Map<String, Integer>();
            //all lower cases
            Set<String> pUpperCase = alphaNumCharCodes.keySet();
            for(String pKey : pUpperCase){
                //the difference between upper case and lower case is 32
                alphaNumCharCodes.put(pKey.toLowerCase(),alphaNumCharCodes.get(pKey)+32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                base64CharCodes.put(pKey,alphaNumCharCodes.get(pKey) - 65);
                base64CharCodes.put(pKey.toLowerCase(),alphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i=0; i<=9; i++){
                alphaNumCharCodes.put(string.valueOf(i),i+48);
                //base 64 numeric starts from 52
                base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        
        public List<Integer> testBits(String pValidFor,List<Integer> nList){
            List<Integer> results = new List<Integer>();
            List<Integer> pBytes = new List<Integer>();
            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
            Integer pFullValue = 0;
            if (bytesBeingUsed <= 1)
                return results;
            for(Integer i=0;i<pValidFor.length();i++){
                pBytes.Add((base64CharCodes.get((pValidFor.Substring(i, i+1)))));
            }   
            for (Integer i = 0; i < pBytes.size(); i++)
            {
                Integer pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
            }
            
            Integer bit;
            Integer targetOctet;
            Integer shiftBits;
            Integer tBitVal;
            Integer n;
            Integer nListSize = nList.size();
            for(Integer i=0; i<nListSize; i++){
                n = nList[i];
                bit = 7 - (Math.mod(n,8)); 
                targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed); 
                shiftBits = (targetOctet * 8) + bit;
                tBitVal = ((Integer)(2 << (shiftBits-1)) & pFullValue) >> shiftBits;
                if (tBitVal==1)
                    results.add(n);
            }
            return results;
        }
    }
    
    /*
     *
     */    
    public class PicklistEntryWrapper{
        
        public PicklistEntryWrapper(){            
        }
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
    }
}