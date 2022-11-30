/******************************************************************************
 * File Name..............:: TimesheetController
 * FileType...............:: Apex Class
 * createdDate............:: 6/25/2015 
 * Created By.............:: Sanjay Singh
 * ****************************************************************************
 * Description............:: This class is controller class for visualforce page                                        
 *                           Time sheet.
 * ****************************************************************************/    
public with sharing class Timesheetcontroller {
    /**** Variable Declaration Starts Here**********/
    public List<projectWrapper> projectWrapperList {get; set;}
    public string selectedWeek {get; set;}
    public boolean isEditable {get; set;}
    public List<DateWrapper> weekDates {get; set;}
    public Date weekStartDate {get; set;}
    public Date WeekEndDate   {get; set;}
    public Timesheet_Week__c tsWeek {get; set;}
    public boolean isCurretWeek {get; set;}
    public boolean isSubmit ;
    public decimal grandTotal {get; set;}
    public Map<integer, decimal> totalMap {get;set;}
    public integer projectRoworder {get;set;}
    public string  componentId {get; set;}
    public boolean isCustomdate {get; set;}
    public Date dt {get; set;}
    public Time_record__c tr {get; set;}

    /****** variable declaration ends*************/
    
    // Constructor
    public Timesheetcontroller(){
        // Initialize variables
        isEditable = true;
        isCurretWeek = true;
        selectedWeek = '';
        tr = new Time_record__c();
        isCustomdate  = false;
        weekDates = new List<DateWrapper>();
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
        findWeek(); 
    }
    
    
    //for rendring custom date input section
    public void enterCustom(){
        isCustomdate = true; 
        tr.Date__c = weekStartDate;
    }
    
    // after entering custom date user click on Go Button then this method will get call
    public void findCustomWeek(){
        if(tr.Date__c != null){
            // User should not be able to select future date
            if(tr.Date__c > date.today()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please select any previous date.')); 
                return ;
            }
            
            isCustomdate  = false;
            weekStartDate = tr.Date__c.toStartofWeek();
            weekEndDate = weekStartDate.addDays(6);
            findWeek();
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter week start date'));      
                    
        }
    
    }
    

    public boolean checkUserAccess(){
        boolean flag  = false;

        TimesheetSetting__c ts = TimesheetSetting__c.getInstance();

        if(ts != null && ts.Can_Edit_Submitted_Timesheet__c ){
            flag= true;
        }

        return flag;
    }

    //This method will find week, means week start date and week end date. 
    //It will create week range string 
    //It checks if the timesheet is submitted for this week then user should not be able to edit it.
    public void findWeek(){
        tsWeek = new Timesheet_Week__c();
        projectWrapperList = new List<projectWrapper>();
        totalMap = new Map<integer, decimal>();
        Map<Date,decimal> tempMap = new Map<Date,decimal>();
        selectedWeek = weekStartDate.format() + ' - '+ WeekEndDate.format();
        if(weekStartDate != null && WeekEndDate != null){
            makeDateList();
            List<Timesheet_Week__c> weekS = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                 Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c,
                 (Select id, Name, Date__c, Hours__c, Project__c from Time_Records__r order by Date__c ASC)
                 FROM Timesheet_Week__c where Week_Start_Date__c =:weekStartDate
                 and Week_End_Date__c =:WeekEndDate and User__c=:UserInfo.getUserId() limit 1]);
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
                    Map<Id, Map<Date, Time_Record__c>> Projectmap = new Map<Id, Map<Date, Time_Record__c>>();
                    
                    for(Time_Record__c tr: tsWeek.Time_Records__r) {
                        if(!Projectmap.containsKey(tr.Project__c)){
                            projectmap.put(tr.Project__c,new Map<date, Time_Record__c>());
                        }
                        projectmap.get(tr.Project__c).put(tr.Date__c, tr);
                        if(!tempMap.containsKey(tr.Date__c)){
                            tempMap.put(tr.Date__c, 0);    
                        }
                        tempMap.put(tr.Date__c, tempMap.get(tr.Date__c)+ (tr.Hours__c != null? tr.Hours__c : 0));
                    }
                    
                    system.debug('=====totalMap==='+totalMap);
                    for(id pid : projectmap.keySet()){
                        projectWrapperList.add(new projectWrapper(pid, projectmap.get(pid), weekDates, projectWrapperList.size()));         
                        
                    }
                }
            }else{
               tsWeek.Status__c = 'Open';
               tsWeek.User__c = UserInfo.getUserId();
               tsWeek.Week_Start_Date__c =  weekStartDate;
               tsWeek.Week_End_Date__c =  WeekEndDate;
               isEditable = true;
               if(isCurretWeek){
                    Date tempstartdate =  weekStartDate.addDays(-1).toStartofWeek() ;
                    Date tempEnddate = tempstartdate.addDays(6);
                    system.debug('---tempstartdate---'+tempstartdate);
                    system.debug('---tempEnddate---'+tempEnddate);
                    List<Timesheet_Week__c> tempweekS = new List<Timesheet_Week__c>([SELECT Id, Name, Week_Start_Date__c, 
                         Week_End_Date__c, Unique_Week_Name__c, User__c, Status__c,
                         (Select id, Name, Date__c, Hours__c, Project__c from Time_Records__r order by Date__c ASC)
                         FROM Timesheet_Week__c where Week_Start_Date__c =:tempstartdate
                         and Week_End_Date__c =:tempEnddate and User__c=:UserInfo.getUserId() limit 1]);
                   system.debug('---tempweekS---'+tempweekS);
                   
                   if(!tempweekS.isEmpty() && !tempweekS[0].Time_Records__r.isEmpty()){
                        system.debug('---tempweekS[0].Time_Records__r---'+tempweekS[0].Time_Records__r);
                        Set<Id> projectSet = new Set<Id>();
                        for(Time_Record__c tr: tempweekS[0].Time_Records__r) {
                            if(tr.Project__c != null){
                                projectSet.add(tr.Project__c);
                            }  
                            
                        }
                        for(id pid : projectSet){
                            projectWrapperList.add(new projectWrapper(pid, null, weekDates, projectWrapperList.size()));         
                            
                        }
                    }
                }
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
        If(projectWrapperList.isEmpty()){
            addRow();    
        }
       
    }
    // Go to next Week 
    public pagereference gotoNextWeek(){
        if(weekStartDate !=null){
            weekStartDate = weekStartDate.addDays(7);
            weekEndDate = weekStartDate.addDays(6);
            if(WeekstartDate == Date.today().toStartofWeek()){
                isCurretWeek = true;    
            }
            findWeek();
        } 
        return null;
    }
    // Go to Previous week
    public pagereference gotoPreviousWeek(){
        if(weekStartDate == null){
            weekStartDate = Date.today().toStartofWeek();
        }
        
        weekStartDate = weekStartDate.addDays(-1).toStartofWeek();
        
        weekEndDate = weekStartDate.addDays(6);
        isCurretWeek = false;
        findWeek();
        return null;
    }
    // for selecting current week
    public pagereference goToCurrentWeek(){
        weekStartDate = Date.today().toStartofWeek();  
        weekEndDate = weekStartDate.addDays(6);
        isCurretWeek = true;
        findWeek();
        return null;
    }
    //make Date list for showing on vf page (table Header)
    public void  makeDateList(){
        weekDates = new List<DateWrapper>();
        for(Integer i=0; i<7;i++){
            Date d = weekStartDate.addDays(i);
            weekDates.add(new DateWrapper(d,weekDates.size()));
        }
    }
    // Save only method
    public pageReference doSave(){
        isSubmit = false;
        save();
        return null;
    }
    
    // It calculate hours whenveruser enters value in table and tabout
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
    
    public void save(){
        
        if(isEditable){
            calculateTotalHours();
            
            if(grandTotal < 40 && isSubmit){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,label.TS_HoursLimitErrorMsg));
                return;
            } 
            if(!projectWrapperList.isEmpty()){
                boolean projError = false;
                for(projectWrapper p : projectWrapperList){
                    if(p.trObj.Project__c == null){
                        p.trObj.Project__c.addError('Project is mandatory.');
                        projError = true;   
                    }
                }
                if(projError){
                    return;
                }
                
                
                try{
                    if(isSubmit){
                        tsWeek.Status__c = 'Submitted';    
                    
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
                    Decimal totalHours = 0;
                    for(projectWrapper pw : projectWrapperList){
                        if(pw.trObj != null && pw.trObj.Project__c  != null &&  !pw.timeRecordmap.isEmpty()){
                            
                            for(DateWrapper dr : weekDates){
                                if(dr.order != null && dr.weekDate != null && pw.timeRecordmap.containsKey(dr.order)){
                                    Time_Record__c tr =  pw.timeRecordmap.get(dr.order);
                                    tr.date__c = dr.weekDate;
                                    tr.Project__c = pw.trObj.Project__c ;
                                    if(tr.Week__c == null)
                                        tr.Week__c = tsWeek.id;
                                    
                                    if((tr.Hours__c == null || tr.Hours__c== 0) && tr.id != null){
                                        trToDelete.add(tr) ;   
                                    }
                                    
                                    if(tr.Hours__c > 0){
                                        trToupsert.add(tr);   
                                    }
                                }
                            }
                        }
                    } 
                    
                    
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
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Time Records Saved Successfully.'));      
                            findWeek();
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Time Records Saved Successfully.'));      
                        findWeek();
                    }    
                }Catch(Exception e){
                    apexpages.addMessages(e);                
                }    
            }
        }    
    }
    
    // Save and submit method 
    // once the user submitted the week timesheet , he/she won't be able to update it later.                           
    public pagereference doSubmit(){
      if(grandTotal > 100){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There should not be more than 100 hours for weekly timesheet.'));
                //  return;
                //   
               //removed the conidtion 
            }  
      else{
       
        isSubmit = true;
        save();
        
        }
        return null;
    }
    
    // To remove project row
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
    
    // Add row if new project
    public pageReference addRow(){
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
    
    // Inner class for binding date and day string 
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
    
    public class projectWrapper{
        public Time_Record__c trObj {get; set;}
        public map<Integer, Time_Record__c> timeRecordmap {get; set;}
        public id projectId {get; set;}
        public integer rowOrder {get; set;}
        public decimal total {get; set;}
        
        
        public projectWrapper(List<DateWrapper> dw, Integer ord){
            this.trObj = new Time_Record__c();
            this.timeRecordmap = new Map<Integer, Time_Record__c>();
            this.rowOrder =rowOrder ;
            this.total = 0;
            for(DateWrapper d : dw){
                timeRecordmap.put(d.order, new Time_Record__c(Date__c = d.weekDate));
            }
        }
        
        public projectWrapper(id projId, Map<date, Time_Record__c> dateWiseTRMap , List<DateWrapper> dw, Integer ord){
            this.trObj = new Time_record__c(Project__c = projId);
            this.projectId = projId;
            this.timeRecordmap = new Map<Integer, Time_Record__c>();
            this.rowOrder = ord;
            this.total = 0;
            for(DateWrapper d : dw){
                
                timeRecordmap.put(d.order, (d.weekDate != null && dateWiseTRMap != null 
                                            && dateWiseTRMap.containsKey(d.weekDate))? dateWiseTRMap.get(d.weekDate): new Time_record__c(date__c = d.weekDate));
                total += (timeRecordmap.get(d.order).Hours__c  != null? timeRecordmap.get(d.order).Hours__c : 0);
            }
        }
    }
   
}