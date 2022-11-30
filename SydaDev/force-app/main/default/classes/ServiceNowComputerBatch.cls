/*
Author : CloudAction
Date : March 2020
Description : Batch Class to fetch  devices from Service Now and populate CMDB.
*/

global class ServiceNowComputerBatch implements Database.Batchable<ServiceNowComputerSystem>, Database.AllowsCallouts, Database.Stateful{
    public integer fetchedRC = 0;
    public integer count = 0;
    public Boolean chainAnotherbatch = true;
    public Boolean firstTime = true;
    
    global Iterable<ServiceNowComputerSystem> start(Database.BatchableContext BC){
        ServiceNowAPIs api = new ServiceNowAPIs();
        List<ServiceNowComputerSystem> devices = api.callServiceNowComputerAPI('ServiceNowCMDB','api/cohnm/remedy_force_computer_api',count);
        fetchedRC = devices.size();
        if (fetchedRC == 0) chainAnotherbatch =false;
        System.debug('device size from start' + fetchedRC);
        if (firstTime) 
           count = fetchedRC + 1;
        else 
           count = count + fetchedRC;
        return devices;
    } 

    global void execute(Database.BatchableContext BC, List<ServiceNowComputerSystem> allDevices){
        RemedyForceComputerSystem RFC = new RemedyForceComputerSystem();
        RFC.createRFComputerSystem(allDevices); 
        System.debug('device size from execut' + allDevices.size());
    }

    global void finish(Database.BatchableContext BC){
       if(chainAnotherbatch){
            ServiceNowComputerBatch  batchjob = new ServiceNowComputerBatch();
            batchjob.firstTime = false;
            batchjob.count = count;
            System.debug(BC.getJobId());
            System.debug('finish-count='+count+', batch='+batchjob.count);
            Database.executeBatch(batchjob,100);
        }else{
            System.debug('Start method signalled that no need to chain another batch another batch job ');
        }
    }
}