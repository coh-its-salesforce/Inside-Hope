@isTest
public class COH_SIP_Header_ControllerTest {
    
    public testMethod static void unitTest() {
       
        Department__c dpt = new Department__c();
        dpt.Name = 'Test Department';
        insert dpt;
         
        Secondary_Department__c secDpt = new Secondary_Department__c();
        secDpt.Name = 'Employee self service';
        secDpt.MenuItem__c = 'DEPARTMENTS';
        secDpt.Secondary_Department_Content__c = 'Test';
        secDpt.Title__c = 'Test1';
        
        insert secDpt;
        
        Menu__c Pmn = new Menu__c();
        Pmn.Name = 'Test';
        Pmn.Desktop_Label__c = 'Header1';
        Pmn.Mobile_Label__c = 'HDR1';
        Pmn.Menu_Order__c = '1';
        Pmn.Menu_URL__c = 'https://www.google.com';
        insert Pmn;
        
        Menu__c mn = new Menu__c();
        mn.Parent_MenuId__c = Pmn.id;
        mn.Name = 'Test3';
        mn.Desktop_Label__c = 'Header1';
        mn.Mobile_Label__c = 'HDR1';
        mn.Menu_Order__c = '2';
        mn.Menu_URL__c = 'https://www.google.com';
        insert mn;
        
        Menu__c mn2 = new Menu__c();
        mn2.Parent_MenuId__c = Pmn.id;
        mn2.Name = 'Test1';
        mn2.Desktop_Label__c = 'Header1';
        mn2.Mobile_Label__c = 'HDR1';
        mn2.Department__c = dpt.id;
        mn2.Menu_Order__c = '3';
        insert mn2;
        
        Menu__c mn3 = new Menu__c();
        mn3.Parent_MenuId__c = Pmn.id;
        mn3.Name = 'Test2';
        mn3.Desktop_Label__c = 'Header1';
        mn3.Mobile_Label__c = 'HDR1';
        mn3.Menu_Order__c = '4';
        mn3.Secondary_Department__c = secDpt.id;
        insert mn3;
        
        ShortCut_Link_Group__c slg = new ShortCut_Link_Group__c();
        slg.Name = 'group1';
        slg.Group_Name__c = 'Testgroup';
        slg.Group_Order__c = 1;
        slg.Link__c = 'https://www.gmail.com';
        insert slg;
        
        ShortCut_Link__c sl = new ShortCut_Link__c();
        sl.Name = 'group2';
        sl.Link_Url__c = 'https://www.google.com';
        sl.Mobile_link__c = true;
        sl.Order__c = 1;
        sl.Group__c = slg.id;
        insert sl;
          
        COH_SIP_Header_Controller.MenuWrapper MW0 = new COH_SIP_Header_Controller.MenuWrapper();       
        MW0.menuName = 'alpha1';        
        MW0.id = 'alpha1';        
        MW0.name = 'alpha1';        
        MW0.url = 'alpha1'; 
        MW0.Desktop_Label = 'Test';
        MW0.Mobile_Label = 'Tst1';
                          
        COH_SIP_Header_Controller.MenuWrapper MW1 = new COH_SIP_Header_Controller.MenuWrapper();        
        MW1.menuName = 'alpha1';        
        MW1.id = 'alpha1';        
        MW1.name = 'alpha1';        
        MW1.url = 'alpha1';        
        MW1.compareTo(MW1);                
        MW1.name = 'bravo1';       
        MW0.compareTo(MW1);
           
        COH_SIP_Header_Controller Hctr = new COH_SIP_Header_Controller();
        Hctr.GetHeaderMenu();
        Hctr.CreateSubMenu();
        Hctr.getCustomMenus();
        Hctr.Shortcut();
        
    }
}