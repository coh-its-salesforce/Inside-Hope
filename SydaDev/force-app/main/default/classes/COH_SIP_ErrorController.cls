/*
 * This is the controller for the COH_SIP_Error Visualforce Page
 * Tim Hughes
 */ 
public class COH_SIP_ErrorController {
    public string mErrorMessage {get; set;}
    public string mException {get; set;}
    public string mContact {get;set;}
    
    PRIVATE FINAL STRING CONTACT_SALESFORCE_ADMIN = 'Please contact your Salesforce administrator.';
    PRIVATE FINAL STRING HOMEPAGE_URL = '/apex/COH_SIRP_HOME_PAGE';
    PRIVATE FINAL STRING GENERIC_ERROR_MESSAGE = 'An unexpected error occured';
    
    /*
     * This constructor builds the error messages the page will dislay based on parameters set using the PageReference.getParameters() function
     * 
     * @param	errorMessage 				The errorMessage to show the user. 
     * 										If there is no errorMessage parameter the GENERIC_ERROR_MESSAGE string will be output the user.
     * 
     * @param	exception					The exception that is causing this error to occur. Displayed for the user but mainly useful for administrators diagnosing the error
     * 										If there is no excpetion parameter, then no excpetion messsage will be displayed to the user.
     */ 
    public COH_SIP_ErrorController() {
        PageReference currentPage = ApexPages.currentPage();
        Map<string, string> pageParameters = currentPage.getParameters();
        
        if (pageParameters != null && pageParameters.size() > 0) {
            if (pageParameters.get('errorMessage') != null) {
				mErrorMessage = pageParameters.get('errorMessage');
            }
            else {
                mErrorMessage = GENERIC_ERROR_MESSAGE;                
            }

            if (pageParameters.get('exception') != null) {
				mException = pageParameters.get('exception');
            }               
        }
        else {
            mErrorMessage = GENERIC_ERROR_MESSAGE;            
        }
        mContact = CONTACT_SALESFORCE_ADMIN;
    }
    
    /*
     * Redirects to the iHope homepage.
     */ 
    public PageReference redirectToHomepage() {
        PageReference homePage = new PageReference(HOMEPAGE_URL);
        homepage.setRedirect(true);
        return homepage;
    }
}