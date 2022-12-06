public class createPortalUserBat implements Database.batchable<sObject>,Database.stateful{
    public id ProfileId;
    static String uName;
    public Map<id,User> userMap;
    public createPortalUserBat(){
        
        
        
    }
    public database.querylocator start(Database.BatchableContext batch){
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Immigration Sevices').getRecordTypeId();
        List<id> contactId = new List<id> ();
        for(User u:[select ContactId from user where createddate = TODAY]){
            
            if(u.ContactId != null){
                
                contactId.add(u.contactId);
            }
        }
        String query = 'select id,Dependents_Info__c,FirstName,LastName,Email from contact where recordtypeId =: recTypeId and createdDate =TODAY';
        if(contactId.size() >0){
            query += ' and id NOT IN:contactId';
        }
        
        return Database.getQueryLocator(query);    
    }
    
    public void execute(Database.BatchableContext bt, List<Contact> conList){
        
        globalStaticVar.executeforbatch = false;
        
        List<User> userList = new List<User>();
        userMap = new Map<id,User>();
        system.debug('uName'+uName );
        uName = UserInfo.getUserName();
        ProfileId = [select id from Profile where Name='international services'].id;
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail= true; 
        for(Contact conRec : conList){
            User portalUser = new User();
            portalUser.ProfileId = ProfileId;
            portalUser.ContactId = conRec.id;
            portalUser.LastName = conRec.LastName;
            portalUser.Firstname = conRec.Firstname;
            if(uName.indexOf('.org')+4 < uName.length()){ 
                portalUser.username = conRec.Email+uName.substring(uName.indexOf('.org')+5,uName.length()) + '.Immigration'; 
            }else{
                portalUser.username = conRec.Email +'.Immigration';
            }
            portalUser.Email = conRec.Email;
            portalUser.emailencodingkey='UTF-8'; 
            portalUser.languagelocalekey='en_US'; 
            portalUser.localesidkey='en_US'; 
            portalUser.country='United States'; 
            portalUser.IsActive =true; 
            portalUser.timezonesidkey='America/Los_Angeles'; 
            
            String temp = conRec.Firstname.length() > 1 ? conRec.Firstname.substring(0,1) :''; 
            temp += conRec.LastName.length() > 4 ? conRec.LastName.substring(0,3): conRec.LastName; 
            portalUser.Alias = temp +'.IS';  
            
            userList.add(portalUser);
            userMap.put(conRec.Dependents_Info__c,portalUser);
        }
        Database.insert(usermap.values(),dlo);
        
    }
    
    public void finish(Database.BatchableContext bt){
        List<Visa__c> visaList = new List<Visa__c>();
        globalStaticVar.executeforbatch = false;
        
        if (userMap != null) {
            for(Id vId : userMap.keySet()){
                Visa__c v = new Visa__c(Id = vId,Community_User_Name__c = userMap.get(vId).Id);
                visaList.add(v);
            }
            if(visaList.size()>0){
                update visaList;
            }
        }
    }
}