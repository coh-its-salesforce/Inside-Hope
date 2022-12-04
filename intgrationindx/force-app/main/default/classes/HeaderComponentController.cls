global class HeaderComponentController {
    global boolean LoginPage { get;  set;}
    
    global List<String> getTabList(){
        List<String> options = new List<String>();
        options.add('ABOUT US');
        options.add('HR & WORK LIFE');
      /* options.add('SITES'); */
        options.add('DEPARTMENTS');
        if(UserInfo.getUserType() != 'Guest' )
            options.add('CHATTER');
     /* options.add('DIRECTORY & RESOURCES'); */
        options.add('RESOURCES & TOOLS');
        options.add('SHORTCUTS');
        return options;
    }
    
    @remoteAction
    global static string loginUser(String userName, String password){
        string s = 'this is test';
        pagereference p = Site.login(username, password, '/COHHome');
        if(p!=null)
        s = p.geturl(); 
        return s;
    }
    
}