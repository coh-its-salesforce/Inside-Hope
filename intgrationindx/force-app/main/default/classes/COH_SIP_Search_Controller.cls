public class COH_SIP_Search_Controller {
    public string txtSearch{get;set;}
    public pageReference Search(){
        // Changes Made by sanjay
        // Added page Name and parameter
        PageReference Page = New PageReference('/apex/search?keyword='+txtSearch);
        return page.setRedirect(true);
    }
}