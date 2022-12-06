public with sharing class COH_SIP_Header_Controller {
public list<ShortCut_Link__C> Links {get;set;}
public list<ShortCut_Link_Group__c> Link_Group {get;set;}
public list<ShortCut_Link__C> Mobile_Links {get;set;}
public list<ShortCut_Link_Group__c> Mobile_Link_Group {get;set;}
public String userPersona {get;set;}
public list<SelectOption> userPersonaList {get;set;}
Public List<Menu__c> menuheaderList{get;set;}
Public List<Menu__c> menuSubList{get;set;}
    
    public COH_SIP_Header_Controller(){
        //addingDepartment();
        GetHeaderMenu();
        CreateSubMenu();
        SetUserPersona();
        Shortcut();
    }
    
    public void GetHeaderMenu()
    {    
        menuheaderList= [Select id,Name, Desktop_Label__c, Mobile_Label__c, Menu_Order__c,Parent_MenuId__c,Menu_URL__c,Sub_Menu__c from menu__c where Parent_MenuId__c = null order by Menu_Order__c ASC];
        /*for (Menu__c mastMenList :[Select id,Name,Menu_Order__c,Parent_MenuId__c,Menu_URL__c from menu__c order by Menu_Order__c ASC]){
            if(mastMenList.Parent_MenuId__c == null)
                menheaderList.add(mastMenList.Name);
        }*/
    }
 
    public void CreateSubMenu()
    {    
        menuSubList= [Select id,Name, Desktop_Label__c, Mobile_Label__c, Menu_Order__c,Parent_MenuId__c, Department__c, Secondary_Department__c, Menu_URL__c,Sub_Menu__c from menu__c where Parent_MenuId__c != null order by Name ASC];
        // create a map for menuwrapper 
        mapMenuWrapper = new Map<String, List<MenuWrapper>>();
        
        //Create Sub Menu By Header menu items
        if(menuSubList != null ) {
            for(Menu__c menuHeader : menuheaderList) {
                for(Menu__c menu : menuSubList) {
                    if(menu.Parent_MenuId__c == menuHeader.id)
                    {
                        MenuWrapper mw = new MenuWrapper();
                        mw.Name = menu.Name;
                        mw.menuName = menuHeader.Name;
                        mw.id = menu.id;
                        mw.Desktop_Label = menu.Desktop_Label__c;
                        mw.Mobile_Label = menu.Mobile_Label__c;
                        
                        if(menu.Menu_URL__c != null)
                        {
                            mw.url = menu.Menu_URL__c;
                        }
                        else if (menu.Department__c != null)
                        {
                            mw.url = '/apex/DepartmentPortal?id='+ menu.Department__c;   
                        }
                        else if (menu.Secondary_Department__c != null)
                        {
                            mw.url = '/apex/SIRP_SecondaryDepartment?isSecondary=true&id='+ menu.Secondary_Department__c;                 
                        }
                        
                        if(mapMenuWrapper.containsKey(menuHeader.Name)) {
                            List<MenuWrapper> tempList = mapMenuWrapper.get(menuHeader.Name);
                            tempList.add(mw);
                        } else {
                            mapMenuWrapper.put(menuHeader.Name, new List<MenuWrapper>{mw});
                        }
                    }
                }
            }    
        }
        
        for(String key : mapMenuWrapper.keySet()) {
            List<MenuWrapper> lstMenuWrapper = mapMenuWrapper.get(key);
            if(lstMenuWrapper != null && !lstMenuWrapper.isEmpty()) {
                menuContains += key + ';';
                lstMenuWrapper.sort();
            }
        }
    }    
    
    public void SetUserPersona()
    {
        userPersonaList = new list<SelectOption>();
        list<ShortCut_Link_Group__c> shortCutGroups = [select Group_Name__c from ShortCut_Link_Group__c order by Group_Name__c ASC];
        for(ShortCut_Link_Group__c shortCutGroup : shortCutGroups)
        {
            if(shortCutGroup != null && shortCutGroup.Group_Name__c != null)
            {
                userPersonaList.add(new SelectOption(shortCutGroup.Group_Name__c, shortCutGroup.Group_Name__c));
            }
        }        
        
        String userDepartment = [Select id, name, Displayname__c, Department from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Department;       
        boolean IsPhysician = [Select id, name, Department, Is_Physician__c from User where Id = :UserInfo.getUserId() and IsActive=true limit 1].Is_Physician__c;              
        If(IsPhysician)
        {
            userPersona = 'Physicians';
        }
        else
        {     
            /* 01/27/2020 Commented the below reference to PeopleSoft and added code for User Object, input from Frank Salinas */
          // List<PeopleSoft__c> userPersonas = [Select Persona__c from PeopleSoft__c where PeopleSoft__c.name = :userDepartment limit 1];
            List<User> userPersonas = [Select Persona__c from User where Id = :UserInfo.getUserId() limit 1];
            if(!userPersonas.isEmpty()){
                userPersona = userPersonas[0].Persona__c;
            }
            else
            {
                userPersona = 'Business Support Services';
                System.debug('userPersona = Business Support Services');    
            }
        }        
    }
    
    public pageReference SwitchUserPersona()
    {
        Shortcut();
        system.debug('userPersona ' + userPersona);
        return null;
    }
    
    public void Shortcut()
    {
        try {            
            Set<String> lstPeopleSoftResearchNames = new Set<String>();  
            
            ShortCut_Link_Group__c shortCutGroupByPersona = [select id,Group_Name__c,Group_Order__c,Link__c from ShortCut_Link_Group__c where Group_Name__c = :userPersona order by Group_Order__c limit 1];
            //Links = [Select Name, Link_Url__c, Group__c,Order__c From ShortCut_Link__C order by Name ];
            Link_Group= [select id,Group_Name__c,Group_Order__c,Link__c from ShortCut_Link_Group__c where Group_Name__c != :userPersona order by Group_Order__c ];
            Link_Group.add(0, shortCutGroupByPersona);
            
            /*String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
            if(userAgent.contains('iPhone') || userAgent.contains('Android')) {
                Mobile_Links = Links;
                Mobile_Link_Group = Link_Group;
            }
            else 
            {*/
                Links = [Select Name, Link_Url__c, Group__c,Order__c From ShortCut_Link__C where Group__c = :shortCutGroupByPersona.Id order by Name ];
            //}
            
            
        } catch(Exception e) {            
            System.debug('The following exception has occurred: ' + e.getMessage());            
        }       
    }
    
    public class MenuWrapper implements Comparable {
        
        public String menuName {get;set;}
        public String id {get;set;}
        public String name {get;set;}
        public String url {get;set;}
        public String Desktop_Label {get;set;}
        public String Mobile_Label {get;set;}
        
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
        MenuWrapper compareToItem = (MenuWrapper)compareTo;
        if (name == compareToItem.name) return 0;
        if (name > compareToItem.name) return 1;
        return -1;        
        }
    }
    
    public Map<String, List<MenuWrapper>> mapMenuWrapper {get;set;}    
    public String menuContains {get;set;} 
    
   public String getCustomMenus()
    {
        String options = '';
        List<String> menuHeaderList = new List<String> ();
        for (Menu__c masterMenuList :[Select id,Name,Menu_Order__c,Menu_URL__c from Menu__c order by Menu_Order__c ASC]){
              // menuHeaderList.add(masterMenuList.Name);
              
               options += masterMenuList.Name + ';';
               
        }
       /* Schema.DescribeFieldResult fieldResult = Department__c.MenuItem__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options += f.getLabel()+';';
        }
        if(menuHeaderList.size() > 0) {
            options = options.subString(0, options.length() - 1);
        }*/
        return options;
    }
    
        /*public void addingDepartment() {
        mapMenuWrapper = new Map<String, List<MenuWrapper>>();
        for(String head : getCustomMenus().split(';')) {
            mapMenuWrapper.put(head, new List<MenuWrapper>());
        }
        for(Department__c dep : [Select Id, Name, Image_Attachment_Id__c, Menu__c,Menu__r.Name,Department_URL__c,MenuItem__c from Department__c order by Name ASC]) {
            
            if(dep.Menu__c != null) {
                for(String menu : dep.Menu__r.name.split(';')) {
                    MenuWrapper mw = new MenuWrapper();
                    mw.menuName = menu;
                    mw.id = dep.Id;
                    mw.name = dep.Name;
                    //mw.url = dep.Department_URL__c;
                    mw.url = '/apex/DepartmentPortal?id='+dep.Id;
                    if(mapMenuWrapper.containsKey(menu)) {
                        List<MenuWrapper> tempList = mapMenuWrapper.get(menu);
                        tempList.add(mw);
                    } else {
                        mapMenuWrapper.put(menu, new List<MenuWrapper>{mw});
                    }
                }
            }
        }
        
        for(Secondary_Department__c sDep : [Select Id, Name, Menu__c,Menu__r.Name,Secondary_Dep_URL__c,MenuItem__c from Secondary_Department__c order by Name ASC]) {
            
            if(sDep.Menu__c != null) {
                for(String menu : sDep.Menu__r.name.split(';')) {
                    MenuWrapper mw = new MenuWrapper();
                    mw.menuName = menu;
                    mw.id = sDep.Id;
                    mw.name = sDep.Name;
                    //mw.url = sDep.Secondary_Dep_URL__c;
                   mw.url = '/apex/SIRP_SecondaryDepartment?isSecondary=true&id='+sDep.Id;
                    if(mapMenuWrapper.containsKey(menu)) {
                        List<MenuWrapper> tempList = mapMenuWrapper.get(menu);
                        tempList.add(mw);
                    } else {
                        mapMenuWrapper.put(menu, new List<MenuWrapper>{mw});
                    }
                }
            }
        }
        
        
        
        for(String key : mapMenuWrapper.keySet()) {
            List<MenuWrapper> lstMenuWrapper = mapMenuWrapper.get(key);
            if(lstMenuWrapper != null && !lstMenuWrapper.isEmpty()) {
                menuContains += key + ';';
                lstMenuWrapper.sort();
            }
        }
    }*/
    
    
}