/*
*	Name: TriggerHelper
*	@author: Matt Graves
*	@version: 1.0
*/
public class TriggerHelper {
    // Static variables are local to the context of a Web request  
    // (or testMethod during a runTests call)  
    // Therefore, this variable will be initialized as false  
    // at the beginning of each Web request which accesses it.  

    private static boolean alreadyUpdated = false;


    public static boolean hasAlreadyUpdated() {
        return alreadyUpdated;
    }

    // By setting the variable to true, it maintains this  
    // new value throughout the duration of the request  
    // (or testMethod)  
    
    public static void setAlreadyUpdated() {
        alreadyUpdated = true;
    }

}