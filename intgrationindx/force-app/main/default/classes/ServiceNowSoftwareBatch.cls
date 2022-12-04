/*
Author : CloudAction
Date : March 2020
Description : Batch Class to fetch  software from Service Now and populate RF CMDB.
*/

global class ServiceNowSoftwareBatch implements Database.Batchable<ServiceNowSoftware>, Database.AllowsCallouts, Database.Stateful{
    public integer fetchedRC = 0;
    public integer count = 0;
    public Boolean chainAnotherbatch = true;
    public Boolean firstTime = true;
    
    global Iterable<ServiceNowSoftware> start(Database.BatchableContext BC){
        ServiceNowAPIs api = new ServiceNowAPIs();
        List<ServiceNowSoftware> softwares = api.callServiceNowSoftwareAPI('ServiceNowCMDB','api/cohnm/remedy_force_software_api',count);
        fetchedRC = softwares.size();
        if (fetchedRC == 0) chainAnotherbatch =false;
        //System.debug('softwares size from start' + fetchedRC);
        if (firstTime) 
           count = fetchedRC + 1;
        else 
           count = count + fetchedRC;
        return softwares;
    } 

    global void execute(Database.BatchableContext BC, List<ServiceNowSoftware> allSoftwares){
        RemedyForceSoftware RFS = new RemedyForceSoftware();
        RFS.createRFSoftware(allSoftwares); 
        System.debug('device size from execute' + allSoftwares.size());
    }

    global void finish(Database.BatchableContext BC){
       if(chainAnotherbatch){
            ServiceNowSoftwareBatch  batchjob = new ServiceNowSoftwareBatch();
            batchjob.firstTime = false;
            batchjob.count = count;
            System.debug(BC.getJobId());
            System.debug('finish-count='+count+', batch='+batchjob.count);
            Database.executeBatch(batchjob,100);
        }else{
            System.debug('Start method signalled that no need to chain another batch job to fetch Software from SN.');
        }
    }
}