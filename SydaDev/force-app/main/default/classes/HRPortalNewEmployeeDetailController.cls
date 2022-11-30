public class HRPortalNewEmployeeDetailController {
	
    @auraenabled
    public static user getUserDetails(){
        return [Select Id, Name, Email from User where id=:userinfo.getUserId() limit 1];
    }
}