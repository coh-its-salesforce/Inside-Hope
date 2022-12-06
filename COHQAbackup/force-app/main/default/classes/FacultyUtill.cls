/**
 * Description : It's a helper class of trigger UpdateNotificatoin.
 *               We are sending email to a particular user in case he/she change some field's values 
 */
 
 
 public with sharing class FacultyUtill {
    
    public static void doAfterfacultyUpdate(List<COH2_Faculty__c> triggerNew,
                                                Map<id, COH2_Faculty__c> triggerNewMap,
                                                    Map<id, COH2_Faculty__c> triggerOldMap){
        
    
        List<COH2_Faculty__c> facultyList = new  List<COH2_Faculty__c>();
        List<COH2_Faculty__c> facultiesToShare = new List<COH2_Faculty__c>();
        for(COH2_Faculty__c ch :triggerNew){
            if(triggerOldMap.get(ch.id).COH2_Delegate_User__c != ch.COH2_Delegate_User__c){
                facultiesToShare.add(ch);
            }
             
            if(ch.COH2_FirstName__c!= triggerOldMap.get(ch.id).COH2_FirstName__c ||
                ch.COH2_MiddleName__c!= triggerOldMap.get(ch.id).COH2_MiddleName__c || 
                ch.COH2_LastName__c!= triggerOldMap.get(ch.id).COH2_LastName__c ||
                ch.COH2_EmailAddress__c!= triggerOldMap.get(ch.id).COH2_EmailAddress__c ||
                ch.COH2_PhoneNo__c!= triggerOldMap.get(ch.id).COH2_PhoneNo__c ||
                ch.COH2_Titles__c!= triggerOldMap.get(ch.id).COH2_Titles__c ||
                ch.COH2_LanguagesSpoken__c!= triggerOldMap.get(ch.id).COH2_LanguagesSpoken__c || 
                ch.COH2_Residencies__c!= triggerOldMap.get(ch.id).COH2_Residencies__c || 
                ch.COH2_Degrees2__c!= triggerOldMap.get(ch.id).COH2_Degrees2__c ||
                ch.COH2_CareTeam__c!= triggerOldMap.get(ch.id).COH2_CareTeam__c ||
                ch.COH2_ClinicalSpecialties__c!= triggerOldMap.get(ch.id).COH2_ClinicalSpecialties__c ||
                // ch.COH2_ResearchSpecialities__c!= triggerOldMap.get(ch.id).COH2_ResearchSpecialities__c ||
                 ch.COH2_PostDocFellowships__c!= triggerOldMap.get(ch.id).COH2_PostDocFellowships__c ||
                 ch.COH2_Fellowships__c  != triggerOldMap.get(ch.id).COH2_Fellowships__c ||
                // ch.COH2_ProgramAffiliation__c!= triggerOldMap.get(ch.id).COH2_ProgramAffiliation__c || 
                // ch.COH2_DepartmentLeadership__c!= triggerOldMap.get(ch.id).COH2_DepartmentLeadership__c ||
                   ch.COH2_Awards__c!= triggerOldMap.get(ch.id).COH2_Awards__c ||
                 ch.COH2_ClinicianOrResearcher__c!= triggerOldMap.get(ch.id).COH2_ClinicianOrResearcher__c ||
                // ch.COH2_LabLocations__c!= triggerOldMap.get(ch.id).COH2_LabLocations__c ||
                  ch.COH2_PrimaryLocations__c!= triggerOldMap.get(ch.id).COH2_PrimaryLocations__c ||
                 ch.COH2_ResearchFocus__c!= triggerOldMap.get(ch.id).COH2_ResearchFocus__c ||
                 ch.COH2_ClinicalFocus__c!= triggerOldMap.get(ch.id).COH2_ClinicalFocus__c ||
                 ch.COH2_BoardCertText__c!= triggerOldMap.get(ch.id).COH2_BoardCertText__c ||
                 ch.COH2_Gender__c!= triggerOldMap.get(ch.id).COH2_Gender__c ){
                 facultyList.add(ch) ;  
            }
        }
        if(facultyList.size() > 0){
            FacultyUtill.processEmailNotificatoin(facultyList, triggerOldMap);
        }
       
        if(facultiesToShare.size() > 0){
            FacultyUtill.autoshareWithDeligateUser(facultiesToShare, triggerOldMap);
        }               
        //checkFieldChangeAndCreateHistoryRecords(triggerNew, triggerOldMap);                                 
    }
    
    
    
    /*
    public static COH2_Faculty_History__c createHistoryRec(COH2_Faculty__c newfacultyobj, 
                                                        COH2_Faculty__c oldFacultyobj,
                                                            Schema.FieldSetMember fsm){
        COH2_Faculty_History__c facHistObj = new COH2_Faculty_History__c();
        facHistObj.COH2_Changes_By__c =UserInfo.getUserId();
        facHistObj.COH2_Faculty__c = newfacultyobj.id;
        facHistObj.COH2_Field__c = fsm.getLabel();
        facHistObj.COH2_Field_Change_Date_Time__c = Datetime.now();
        facHistObj.COH2_New_Value__c = newfacultyobj.get(fsm.getFieldPath()) != null? String.valueOf(newfacultyobj.get(fsm.getFieldPath())):null;
        facHistObj.COH2_Old_Value__c = oldFacultyobj.get(fsm.getFieldPath())!= null? String.valueOf(oldfacultyobj.get(fsm.getFieldPath())):null;
        return facHistObj;
    }
   
   
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }*/   
	
     private static string createRowElementString(string fieldName , string newVal, string oldVal){
         return  '<tr><th> '+fieldName +'</th><td>'+newVal + '</td><td>'+ oldVal+'</td></tr>';
     } 
     
    public static void processEmailNotificatoin(List<COH2_Faculty__c> facultyList,
                                                Map<Id, COH2_Faculty__c> oldValMap){
        
        Map<id, String>  emailBodyMap =  New Map<id, String>();
        List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
        
        if(!facultyList.isEmpty() && oldValMap != null){
            for(COH2_Faculty__c ch : facultyList){
                String bodyStr = '';
                if(ch.COH2_FirstName__c  != oldValMap.get(ch.id).COH2_FirstName__c){
                	bodyStr += createRowElementString('First Name', ch.COH2_FirstName__c, oldValMap.get(ch.id).COH2_FirstName__c);
                }
                if(ch.COH2_MiddleName__c  != oldValMap.get(ch.id).COH2_MiddleName__c){
                	bodyStr += createRowElementString('Middle Name', ch.COH2_MiddleName__c, oldValMap.get(ch.id).COH2_MiddleName__c);
                }
                    
                if(ch.COH2_LastName__c  != oldValMap.get(ch.id).COH2_LastName__c){
                 	bodyStr += createRowElementString('Last Name', ch.COH2_LastName__c, oldValMap.get(ch.id).COH2_LastName__c);
                }
                 /*if(ch.COH2_DOB__c  != oldValMap.get(ch.id).COH2_DOB__c){
                     bodyStr += '<tr><th> DOB </th><td>'+ch.COH2_DOB__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_DOB__c+'</td></tr>';
                }*/                         
                if(ch.COH2_Gender__c  != oldValMap.get(ch.id).COH2_Gender__c){
                	bodyStr += createRowElementString('Gender', ch.COH2_Gender__c, oldValMap.get(ch.id).COH2_Gender__c);
                }  
                
                if(ch.COH2_EmailAddress__c  != oldValMap.get(ch.id).COH2_EmailAddress__c){
                	bodyStr += createRowElementString('Email Address', ch.COH2_EmailAddress__c, oldValMap.get(ch.id).COH2_EmailAddress__c);
                }
                
                if(ch.COH2_PhoneNo__c  != oldValMap.get(ch.id).COH2_PhoneNo__c){
                	bodyStr += createRowElementString('PhoneNo', ch.COH2_PhoneNo__c, oldValMap.get(ch.id).COH2_PhoneNo__c);
                }
                
                if(ch.COH2_Titles__c  != oldValMap.get(ch.id).COH2_Titles__c){
                	bodyStr += createRowElementString('Titles', ch.COH2_Titles__c, oldValMap.get(ch.id).COH2_Titles__c);
                }
                
                if(ch.COH2_LanguagesSpoken__c  != oldValMap.get(ch.id).COH2_LanguagesSpoken__c){
                	bodyStr += createRowElementString('Languages Spoken', ch.COH2_LanguagesSpoken__c, oldValMap.get(ch.id).COH2_LanguagesSpoken__c);
                }
                
                if(ch.COH2_Residencies__c  != oldValMap.get(ch.id).COH2_Residencies__c){
                	bodyStr += createRowElementString('Residencies', ch.COH2_Residencies__c, oldValMap.get(ch.id).COH2_Residencies__c);
                }
                
                if(ch.COH2_CareTeam__c  != oldValMap.get(ch.id).COH2_CareTeam__c){
                	bodyStr += createRowElementString('Care/Disease Team', ch.COH2_CareTeam__c, oldValMap.get(ch.id).COH2_CareTeam__c);
                }
                
                if(ch.COH2_Degrees2__c  != oldValMap.get(ch.id).COH2_Degrees2__c){
                	bodyStr += createRowElementString('Degrees', ch.COH2_Degrees2__c, oldValMap.get(ch.id).COH2_Degrees2__c);
                }
                
                if(ch.COH2_ClinicalSpecialties__c  != oldValMap.get(ch.id).COH2_ClinicalSpecialties__c){
                	bodyStr += createRowElementString('Clinical Specialties', ch.COH2_ClinicalSpecialties__c, oldValMap.get(ch.id).COH2_ClinicalSpecialties__c);
                }
                
                 /*if(ch.COH2_ResearchSpecialities__c  != oldValMap.get(ch.id).COH2_ResearchSpecialities__c){
                     bodyStr += '<tr><th> ResearchSpecialities </th><td>'+ch.COH2_ResearchSpecialities__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_ResearchSpecialities__c+'</td></tr>';
                }*/ 
                if(ch.COH2_PostDocFellowships__c  != oldValMap.get(ch.id).COH2_PostDocFellowships__c){
                	bodyStr += createRowElementString('PostDocFellowships', ch.COH2_PostDocFellowships__c, oldValMap.get(ch.id).COH2_PostDocFellowships__c);
                }
                
                if(ch.COH2_Fellowships__c  != oldValMap.get(ch.id).COH2_Fellowships__c){
                	bodyStr += createRowElementString('Fellowships', ch.COH2_Fellowships__c, oldValMap.get(ch.id).COH2_Fellowships__c);
                }
                               
                /*if(ch.COH2_ProgramAffiliation__c  != oldValMap.get(ch.id).COH2_ProgramAffiliation__c){
                     bodyStr += '<tr><th> ProgramAffiliation </th><td>'+ch.COH2_ProgramAffiliation__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_ProgramAffiliation__c+'</td></tr>';
                }*/  
                /*if(ch.COH2_DepartmentLeadership__c  != oldValMap.get(ch.id).COH2_DepartmentLeadership__c){
                     bodyStr += '<tr><th> DepartmentLeadership </th><td>'+ch.COH2_DepartmentLeadership__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_DepartmentLeadership__c+'</td></tr>';
               }    
                if(ch.COH2_Awards__c  != oldValMap.get(ch.id).COH2_Awards__c){
                     bodyStr += '<tr><th> Awards </th><td>'+ch.COH2_Awards__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_Awards__c+'</td></tr>';
                }
                if(ch.COH2_ClinicianOrResearcher__c  != oldValMap.get(ch.id).COH2_ClinicianOrResearcher__c){
                     bodyStr += '<tr><th> ClinicianOrResearcher </th><td>'+ch.COH2_ClinicianOrResearcher__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_ClinicianOrResearcher__c+'</td></tr>';
                }
                 /*if(ch.COH2_LabLocations__c  != oldValMap.get(ch.id).COH2_LabLocations__c){
                     bodyStr += '<tr><th> LabLocations </th><td>'+ch.COH2_LabLocations__c + '</td><td>'+
                                oldValMap.get(ch.id).COH2_LabLocations__c+'</td></tr>';
                }*/ 
                if(ch.COH2_PrimaryLocations__c  != oldValMap.get(ch.id).COH2_PrimaryLocations__c){
                	bodyStr += createRowElementString('Primary Locations', ch.COH2_PrimaryLocations__c, oldValMap.get(ch.id).COH2_PrimaryLocations__c);
                }
                
                if(ch.COH2_ResearchFocus__c  != oldValMap.get(ch.id).COH2_ResearchFocus__c){
                	bodyStr += createRowElementString('Research Focus', ch.COH2_ResearchFocus__c, oldValMap.get(ch.id).COH2_ResearchFocus__c);
                }
                
                if(ch.COH2_ClinicalFocus__c  != oldValMap.get(ch.id).COH2_ClinicalFocus__c){
                	bodyStr += createRowElementString('Clinical Focus', ch.COH2_ClinicalFocus__c, oldValMap.get(ch.id).COH2_ClinicalFocus__c);
                }
                
                if(ch.COH2_BoardCertText__c  != oldValMap.get(ch.id).COH2_BoardCertText__c){
                	bodyStr += createRowElementString('BoardCertText', ch.COH2_BoardCertText__c, oldValMap.get(ch.id).COH2_BoardCertText__c);
                }
                
                if(bodyStr != ''){
                    //Create a new Email
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    //Set list of people who should get the email
                    FacultyProfileSetting__c fp = FacultyProfileSetting__c.getOrgDefaults(); 
                    if(fp != null && !string.isBlank(fp.Profile_Name__c)){
                        
                        List<Profile> p = [Select id, Name from Profile where name=:fp.Profile_Name__c limit 1];
                        List<User> userList = new List<User>();
                        if(!p.isEmpty()){
                            userList = [Select id,Email from user where isActive = true and profileId =: p[0].id ];
                        }
                        system.debug('=====userList====='+userList.size());
                        if(!userList.isEmpty()){
                            List<String> sendTo = new List<String>();
                            for(User u : userList){
                                sendTo.add(u.Email);
                            }
                            //sendTo.add('sasingh@coh.org');
                            //sendTo.add('cmontgomery@coh.org');
                           // sendTo.add('ahedin@coh.org');                    
                            mail.setToAddresses(sendTo);
                            mail.setSenderDisplayName('COH Org');
                            // Step 4. Set email contents - you can use variables!
                            mail.setSubject('Faculty Record has Been Updated : '+ ch.Name);
                                        
                            String msgBody = 'Hi,</br>'+
                                             '<p>Faculty Record - '+ ch.name +
                                             ' has been modified by User: '+ UserInfo.getName() + '('+UserINfo.getUserName()+'). '+
                                             ' Please find the changes below: </p>'+
                                             ' <Table border="1"><tr><th>Field</th><th>New Value</th><th>Old Value</th></tr>'+
                                             bodyStr+'</table>'+
                                             '<br/>Thanks';
                                             
                            mail.setHtmlBody(msgBody); 
                            mails.add(mail);
                        }
                    }  
                }
            }
            IF(mails.size() > 0){
              //Send all emails in the master list
              Messaging.sendEmail(mails);
            }
        
        }
    }
 
    
    public static void autoshareWithDeligateUser(List<COH2_Faculty__c> facultytoShare, 
                                                Map<Id, COH2_Faculty__c> facultyOldMap){
        If(!facultytoShare.isEmpty()){
            Map<Id, Map<Id,COH2_Faculty__Share>> OldDeligateUser = new  Map<Id, Map<Id,COH2_Faculty__Share>>();   
            List<COH2_Faculty__Share> shareToInsert = new List<COH2_Faculty__Share>();
            List<COH2_Faculty__Share> shareToDelete = new List<COH2_Faculty__Share>();
            for(COH2_Faculty__Share sh : [Select id, ParentId, UserOrGroupId from COH2_Faculty__Share where ParentId in : facultytoShare]){
                if(!OldDeligateUser.containsKey(sh.parentId)){
                    OldDeligateUser.put(sh.parentId, new Map<Id, COH2_Faculty__Share>());
                }    
                OldDeligateUser.get(sh.parentId).put(sh.UserOrGroupId, sh);
            }
            
            
            for(COH2_Faculty__c f : facultytoShare){
                if(f.COH2_Delegate_User__c != facultyOldMap.get(f.id).COH2_Delegate_User__c && facultyOldMap.get(f.id).COH2_Delegate_User__c != null){
                    if(OldDeligateUser.containsKey(f.id) && OldDeligateUser.get(f.id).containsKey(facultyOldMap.get(f.id).COH2_Delegate_User__c)) {
                        shareToDelete.add(OldDeligateUser.get(f.id).get(facultyOldMap.get(f.id).COH2_Delegate_User__c));        
                    }  
                }
                
                
                if(f.COH2_Delegate_User__c != null && f.ownerId != f.COH2_Delegate_User__c && f.COH2_Delegate_User__c != facultyOldMap.get(f.id).COH2_Delegate_User__c){
                    COH2_Faculty__Share fs = new  COH2_Faculty__Share();
                    fs.AccessLevel = 'edit';
                    fs.ParentId = f.id;
                    fs.UserOrGroupId = f.COH2_Delegate_User__c ;
                    shareToInsert.add(fs);
                }
            } 
            if(!shareToInsert.isEmpty()){
                Database.SaveResult[] sr = Database.insert(shareToInsert);
            }
            
            if(!shareToDelete.isEmpty()){
                Database.DeleteResult[] dr=Database.delete(shareToDelete);
            }
        }
    }
     
}