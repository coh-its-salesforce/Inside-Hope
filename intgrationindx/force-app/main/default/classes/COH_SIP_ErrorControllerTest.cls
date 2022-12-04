/*
 * This is the test class for the COH_SIP_ErrorController class
 * Tim Hughes
 */ 
@isTest
private class COH_SIP_ErrorControllerTest {
    PRIVATE STATIC STRING ERROR_MESSAGE = '';
    PRIVATE STATIC STRING EXCEPTION_MESSAGE = '';
    private static COH_SIP_ErrorController mController;
    
    
    /*
     * This tests verifies that a if an errorMessage and exception parameter are supplied, then they are correctly entered in the page
     */ 
    @isTest
    private static void testConstructor0() {
		apexPages.currentPage().getParameters().put('errorMessage', ERROR_MESSAGE);
        apexPages.currentPage().getParameters().put('exception', EXCEPTION_MESSAGE);
        
        test.startTest();
        
        mController = new COH_SIP_ErrorController();
        System.assertEquals(ERROR_MESSAGE, mController.mErrorMessage);
        System.assertEquals(EXCEPTION_MESSAGE, mController.mException);
        
        test.stopTest();
    }
    
    /*
     * This test ensures that if an exception parameter is not supplied, then it is not entered in the page
     */ 
    @isTest
    private static void testConstructor1() {
		apexPages.currentPage().getParameters().put('errorMessage', ERROR_MESSAGE);
        
        test.startTest();
        
        mController = new COH_SIP_ErrorController();
        System.assertEquals(ERROR_MESSAGE, mController.mErrorMessage);
        System.assertEquals(null, mController.mException);
        
        test.stopTest();        
    }

    /*
     * This test ensures that if no parameter is not supplied, then a generic error message is displayed on the page
     */ 
    @isTest
    private static void testConstructor2() {
        
        test.startTest();
        
        mController = new COH_SIP_ErrorController();
        System.assertNotEquals(null, mController.mErrorMessage);
        System.assertEquals(null, mController.mException);
        
        test.stopTest();        
    }   
    
    /*
     * This test ensures that if an errorMessage parameter is not supplied, but an exception message is, then a generic error message is displayed on the page
     */ 
    @isTest
    private static void testConstructor3() {
        apexPages.currentPage().getParameters().put('exception', EXCEPTION_MESSAGE);
        
        test.startTest();
        
        mController = new COH_SIP_ErrorController();
        System.assertNotEquals(null, mController.mErrorMessage);
        System.assertEquals(EXCEPTION_MESSAGE, mController.mException);
        
        test.stopTest();        
    }        
    
    /*
     * This test is used for code coverage, testing the redirect method
     */ 
    @isTest
    private static void testRedirectMethod0() {
        
        test.startTest();
        
        mController = new COH_SIP_ErrorController();
        PageReference redirectedPage = mController.RedirectToHomepage();
        System.assertEquals(true, redirectedPage.getRedirect());
        
        test.stopTest();
        
    }
}