@isTest
public class LookupPageControllerTest {

    @isTest
    public static void test1(){
        LookupPageController a = new LookupPageController();
        a.searchvalue = 'Sample Value';
        a.getRecords();
        a.onkeyupAction();
        a.searchAction();
    }
}