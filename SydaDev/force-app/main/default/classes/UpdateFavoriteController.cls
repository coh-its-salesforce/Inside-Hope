public class UpdateFavoriteController {
    public string UserIDs{get;set;}
    public PageReference loadDefaultLinks()
    {
        try {
            Integer iCount = 0;
            AggregateResult[] physicianIDsToModify = [Select User__c from My_Favourite__c where LastModifiedDate < 2016-01-09T00:00:00Z and User__c in (select id from User where Is_Physician__c = true) group by User__c];
            for (AggregateResult ar : physicianIDsToModify)  {  
                iCount = iCount + 1;
                if(iCount < 20)
                {
                    String userID = (String)ar.get('User__c');
                    UserIDs = UserIDs + ' ' + userID + ' ';
                    system.debug('userID '+ userID);
                    List<My_Favourite__c> favListByUser = new List<My_Favourite__c>();
                    favListByUser = [Select id, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c, LastModifiedDate from My_Favourite__c where 
                                     User__c =:userID order by Master_Favorite_Link__r.URL__c ASC];
                    if(favListByUser != null && favListByUser.size() >= 6 &&  favListByUser.size() < 8)
                    {
                        delete[Select id from My_Favourite__c where User__c =:userID];
                        system.debug('Records Deleted ');
                        /*String userPersona= 'Physicians';
                        String searchClause= '%' + userPersona + '%';
                        List<Master_Favorite_Link__c> lstFavByPersona = [Select id, Name, Link__c, URL__c from Master_Favorite_Link__c where Master_Favorite_Link__c.Persona__c like :searchClause];
                        if (lstFavByPersona != null || lstFavByPersona.size() > 0)   
                        {
                            List<My_Favourite__c> favListForPhysicians = new List<My_Favourite__c>();
                            system.debug('lstFavByPersona '+ lstFavByPersona.size());
                            for(Master_Favorite_Link__c objFavByPersona : lstFavByPersona){
                                My_Favourite__c mf = new My_Favourite__c();
                                mf.Name = objFavByPersona.URL__c;
                                mf.Show_On_Home__c = true;
                                mf.User__c = UserInfo.getUserId();
                                mf.Master_Favorite_Link__c = objFavByPersona.Id;
                                system.debug('mf.Name '+ mf.Name);
                                favListForPhysicians.add(mf);
                                system.debug('favListForPhysicians' + favListForPhysicians.size());
                            }
                            insert favListForPhysicians;
                        }*/
                    }
                }
            }
        } catch(Exception e) {            
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }
        return null;
    }
}