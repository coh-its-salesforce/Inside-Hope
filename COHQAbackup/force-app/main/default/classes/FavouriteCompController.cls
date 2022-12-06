public with sharing class FavouriteCompController {

        public List<My_Favourite__c> favList {get; set;}
        public Integer linkorder {get; set;}
        public boolean editFlag {get; set;}   
        public boolean saveBtnFlag {get; set;}
        public List<FavWrapper> myFavList {get; set;}
        public boolean msgFlag{get; set;}
        public string msg{get; set;}
        public string msgType{get; set;}
        Public Map<String,Id> favMapSetting;
        public FavouriteCompController(){
         
           
            queryMyFavLinks();
            string s = apexpages.currentPage().getparameters().get('editmode');
            editFlag = false;
            msgFlag = false;
            saveBtnFlag  = false;
            if(s == '1'){
                editFlag = true;
                saveBtnFlag = true;
                msgFlag = false;
            }
        } 
        
        public void queryMyFavLinks(){
             myFavList = new List<FavWrapper>();
             
             for(My_Favourite__c mf : [Select id, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c from My_Favourite__c where 
                                              User__c =: UserINfo.getUserId() order by Master_Favorite_Link__r.URL__c ASC]){
                 myFavList.add(new FavWrapper(mf,myFavList.size()));
             }
        }
        
        public void doEdit(){
            editFlag = true;
            saveBtnFlag = true;
            msgFlag = false;
        }
        
        public pageReference OnchangeLink(){
            if(linkorder != null){
                FavWrapper fv = myFavList[linkorder];
                if(fv.SelectedValue !='SELECT'){
                    List<string> s = fv.SelectedValue.split(' : '); 
                    if(s.size() == 2){
                        fv.linkURl =  s[1]; 
                    }
                }else{
                  fv.linkURl = '';  
                }
            }
            return null;
        }
        
        public List<SelectOption> getAllFevouriteLinsList(){
           /* Map<String,Favourite_Links__c> favMapSetting = Favourite_Links__c.getAll();
            List<SelectOption> options = new List<SelectOption>();
            if(favMapSetting != null && favMapSetting.size() > 0){            
                for(string s : favMapSetting.keySet()){
                    string val = s.toUpperCase()+' : ' + favMapSetting.get(s).URL__c;
                    options.add(new SelectOption(val, val));
                }
                options.sort();
                options.add(new SelectOption('SELECT', '--SELECT--'));
            }else{
                options.add(new SelectOption('NONE', 'Not Available'));
            }
            return options;*/
            
            
            List <Master_Favorite_Link__c> masterFavList = [select id,URL__c,Link__c from Master_Favorite_Link__c order by URL__c];
            //masterFavList.sort(masterFavList.URL__c);
            favMapSetting = New Map <String,Id>();
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('SELECT', '--SELECT--'));
            if(masterFavList.size() > 0){            
                for(Master_Favorite_Link__c s : masterFavList){
                    string val = s.URL__c.toUpperCase()+' : ' + s.Link__c;
                    //options.add(new SelectOption(val+' : '+favMapSetting.get(s).id, val));
                    options.add(new SelectOption(val, val));
                    favMapSetting.put(val,s.id);
                }
                //options.sort();
               // options.add(new SelectOption('SELECT', '--SELECT--'));
            }else{
                options.add(new SelectOption('NONE', 'Not Available'));
            }
            return options;
        }
        
        
        public void removeLink(){
            system.debug('============='+linkorder );
            if(linkorder != null){
                try{
                    if(myFavList[linkorder].fav.id != null){
                        delete new My_Favourite__c(id=myFavList[linkorder].fav.id);
                    }
                    myFavList.remove(linkorder);
                    integer i=0;
                    for(FavWrapper f :myFavList){
                        f.order= i;
                        i++;
                    }
                    msgFlag = true;
                    msgType = 'success';
                    msg = 'Row deleted successfully'; 
                }catch(Exception e){
                    editFlag = true;
                    msgFlag = true;
                    msgType = 'error';
                    msg = e.getMessage();   
                }    
            }
        }
        
        public pagereference doSave(){
        system.debug('Inside doSave Method');
        system.debug('My Favorite List :' + myFavList);
            
            try{
                List<My_Favourite__c> favList = new List<My_Favourite__c>();
                integer counter = 0;
                boolean errorFlag = false;
                Set<string> tempSet = new Set<string>();
                for(FavWrapper fv: myFavList){
                  boolean er = false;
                  if(fv.fav.show_on_Home__c)  {
                     counter ++; 
                  }
                  system.debug('=====fv==='+fv);
                    if(fv.SelectedValue =='SELECT' || fv.SelectedValue == 'NONE'){
                      errorFlag = true;
                      er = true;
                      msgFlag = true;
                      msgType = 'error';
                      if(fv.SelectedValue == 'NONE'){
                            msg = 'Link Not available, Contact Admin';
                      }
                      else
                          msg = 'Please select url.';
                      break;
                  }else{
                      if(tempSet.contains(fv.SelectedValue)){
                          errorFlag = true;
                          er = true;
                          msgFlag = true;
                          msgType = 'error';
                          msg = 'Please select unique url in each row.';
                          break; 
                      }else{
                          tempSet.add(fv.SelectedValue);
                      }
                      
                      List<string> s = fv.SelectedValue.split(' : ');
                      system.debug('s======'+s+'======'+s.size());
                      //system.debug('fv.fav.Master_Fav_List :' + s[2].trim());
                      if(!s.isEmpty() && s.size() ==2){
                          fv.fav.Name = s[0].trim();
                          //fv.fav.URL__c = s[1].trim();
                          
                          
                          fv.fav.Master_Favorite_Link__c =favMapSetting.get(fv.SelectedValue) ;
                          
                      }
                      //system.debug('fv.fav.Name========'+fv.fav.Name);
                      //system.debug('fv.fav.URL__c========'+fv.fav.URL__c);
                      favList.add(fv.fav);
                  }
                }
               
                /*if(counter  > 4){
                    errorFlag = true; 
                    msgFlag = true;
                    msgType = 'error';
                    msg = 'Only 4 linkes can be selected at a time.';
                   
                }*/
                
                if(errorFlag ){
                     msgFlag = true;
                     msgType = 'error';
                    return null;
                }
                upsert favList;
                
                editFlag = false;
                saveBtnFlag= false;
                msgFlag = true;
                msg = 'Link saved successfully.';
                msgType = 'success';
                queryMyFavLinks();
            }catch(Exception e){
                editFlag = true;
                msgFlag = true;
                msgType = 'error';
                msg = e.getMessage();            
                
            }
            return null;
        }
        
        public void addNew(){
            myFavList.add(new FavWrapper(new My_Favourite__c(USer__c = UserInfo.getUserId()), myFavList.size()));
            system.debug('My Fav List in AddNew Method :' + myFavList.size());
            saveBtnFlag = true;
            msgFlag = false;
            msgType = '';
            msg =''; 
        }
        
        public void doCancel(){
        try{
            editFlag = false;
            saveBtnFlag = false;
            List<FavWrapper> temp = new List<FavWrapper>();
            for(FavWrapper mf :myFavList){
                if(mf.fav.id != null){
                    temp.add(mf);
                }
            }
            myFavList.clear();
            myFavList = temp ;
          }
           catch(Exception e)
           {
           }  
        }
        
        public List<FavWrapper> getMyFavlinks(){            
            List<FavWrapper> linkList = new List<FavWrapper>();
            List<My_Favourite__c > mfList = new List<My_Favourite__c>();
            id  userid= UserINfo.getUserId();
            try
            {
                mfList = Database.query('Select id, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c from My_Favourite__c where User__c =: userid and Show_On_Home__c = true order by Master_Favorite_Link__r.URL__c ASC');
                
                /* mfList = [Select id, Show_On_Home__c,Master_Favorite_Link__c,Master_Favorite_Link__r.Link__c,Master_Favorite_Link__r.URL__c from My_Favourite__c where 
				User__c =: UserINfo.getUserId() and Show_On_Home__c = true order by Master_Favorite_Link__r.URL__c ASC Limit 50000];*/
                
                for(My_Favourite__c mf : mfList){
                    linkList.add(new FavWrapper(mf,linkList.size()));
                }
            }
            catch(Exception e) {            
                System.debug('The following exception has occurred: ' + e.getMessage());            
            } 
            
            return linkList;
        }
            
        public class FavWrapper {
            public string label   {get;set;}
            public string SelectedValue  {get;set;}
            public string linkURL {get;set;}
            public My_Favourite__c fav {get; set;}
            //public Master_Favorite_Link__c masterFavList {get; set;}
            public integer order {get; set;}
            public boolean isChecked {get;set;}
            public FavWrapper(My_Favourite__c f, integer i){
            try
            {
                this.label = f.Master_Favorite_Link__r.URL__c;
                this.SelectedValue = (f.id != null? (f.Master_Favorite_Link__r.URL__c.toUpperCase() +' : '+f.Master_Favorite_Link__r.Link__c): null);
                this.order = i;
                this.linkURL = f.Master_Favorite_Link__r.Link__c ;
                this.fav = f;
                this.isChecked = false;
                }
                catch(Exception e)
                {
                
                }
            }
        }
    }