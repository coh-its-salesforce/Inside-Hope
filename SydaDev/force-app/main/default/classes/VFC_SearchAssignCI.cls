/*
** Name : VFC_SearchAssignCI 
** Autor : veenesh.vikram
** Description : Controller for VF Page "VF_SearchAssignCI" to display CI's assigned to the client
**               and also lets assign new CI's to Client.
** Date : 1 July 2015
*/
public class VFC_SearchAssignCI {

//Variable decleration
Public String searchStr{get;set;}
Public String searchResults{get;set;}
Public String userid{get;set;}
Public String assignResults{get;set;}
Public List<BMCServiceDesk__BMC_BaseElement__c> CIList{get;set;}
Public List<BMCServiceDesk__BMC_BaseElement__c> SearchList{get;set;}
Public BMCServiceDesk__BMC_BaseElement__c ci{get;set;}
Public String classsel{get;set;}
Public List<id> lstClasses{get;set;}   

    //Constructor
    public VFC_SearchAssignCI(ApexPages.StandardController controller) {
    ci = (BMCServiceDesk__BMC_BaseElement__c)controller.getRecord();

    //Get the client id from URL.
    userid = ApexPages.currentPage().getParameters().get('uid');
    if(userid != null){
        //Query all CI's assigned to the client and display. 
        CIList = [SELECT name,BMCServiceDesk__ManufacturerName__c, BMCServiceDesk__Model__c, BMCServiceDesk__SerialNumber__c,BMCServiceDesk__CITag__c,BMCServiceDesk__PrimaryClient__c from BMCServiceDesk__BMC_BaseElement__c 
                 WHERE BMCServiceDesk__PrimaryClient__c =:userid ];
        //Display number of results.         
        assignResults = 'BASE ELEMENTS ['+String.valueOf(CIList.size())+']';
    
    }
    }

    //Method to Search CI's based on the search string entered by user.
    public pagereference SearchItems(){
    //Check for length of search string
    if(searchStr.length() > 1){
    
    lstClasses = new List<Id>();
    string srchstr = String.escapeSingleQuotes(searchStr);
        for(BMCServiceDesk__CMDB_Class__c clas : [SELECT id,name,BMCServiceDesk__ClassName__c from BMCServiceDesk__CMDB_Class__c WHERE BMCServiceDesk__SuperClass__c= 'BMC_ComputerSystem' AND BMCServiceDesk__ClassName__c like 'COH_%' ]){
            lstClasses.add(clas.id); 
        }
        
        //Create Search Query
        String query = 'SELECT name,BMCServiceDesk__ManufacturerName__c, BMCServiceDesk__Model__c, BMCServiceDesk__SerialNumber__c,BMCServiceDesk__CITag__c,BMCServiceDesk__PrimaryClient__c from BMCServiceDesk__BMC_BaseElement__c WHERE (name like '+'\'%'+srchstr+'%\'' + ' OR BMCServiceDesk__CITag__c like '+'\'%'+srchstr+'%\''+ ' OR Primary_Client_Name__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__SerialNumber__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__Model__c like '+'\'%'+srchstr+'%\''+ ' OR BMCServiceDesk__ManufacturerName__c like '+'\'%'+srchstr+'%\'' + ') AND (BMCServiceDesk__CMDB_Class__c in :lstClasses)';

        //Query the search results.
        SearchList = Database.Query(query);

        //Display number of search results.  
        searchResults = 'BASE ELEMENTS ['+String.valueOf(SearchList.size())+']';
       }
       //If search string is smaller than 2 characters, show warning.
       else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning,'Enter a Search string with minimum 2 characters.'));
       }
    return null;  
    }
    
    //Method to update CI(Assign client to CI).
    public pagereference saveme()
    { 
        try{
           //Update the CI's     
           update SearchList;
           //Update the List of Assigned CI's
           CIList = [SELECT name,BMCServiceDesk__ManufacturerName__c, BMCServiceDesk__Model__c, BMCServiceDesk__SerialNumber__c,BMCServiceDesk__CITag__c,BMCServiceDesk__PrimaryClient__c from BMCServiceDesk__BMC_BaseElement__c 
           WHERE BMCServiceDesk__PrimaryClient__c =:userid ];
        }  
        //Catch any Exception that Occured.
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getmessage()));
        }
        return null;  

    }

}