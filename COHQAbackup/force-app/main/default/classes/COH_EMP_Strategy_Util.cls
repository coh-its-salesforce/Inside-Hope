/*
* This class contains the methods for handling trigger events for Evaluation Request objects.
* 
* Abhishek Kumar
* City of Hope
* Copyright (c) 2018
* 
* No portion of this code may be copied, transferred, or transmitted
* in any form (written, electronic, or otherwise) without the prior
* written consent from the City of Hope.
*  
*/
public class COH_EMP_Strategy_Util {
    /*
* Calculate and Returns a Date, after adding working days, the method can be called
* from the appropriate trigger objects.
* 
* @param StartDate				Start Date.
* @param BusinessDaysToAdd		Number of Days to be added to the start date.
* @return						Working Date value of Start Date + Number Of Days.
* 
*/
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd )
    {
        //Add or decrease in BusinessDaysToAdd days 
        Date finalDate = StartDate;
        integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
        while(BusinessDaysToAdd != 0)
        {
            finalDate = finalDate.AddDays(direction);
            if (!isWeekendDay(finalDate))
            {
                BusinessDaysToAdd -= direction;                
            }
        }
        
        return finalDate;
    }
 
        /*
* Calculate the day is a weekend
* 
* @param dateParam				A Given Date.
* @return						True or False, if the date is a weekend or not.
* 
*/
    public static Boolean IsWeekendDay(Date dateParam)
    {
        
        boolean result = false;
        //Recover the day of the week
        Date startOfWeek = dateParam.toStartOfWeek();
        Integer dayOfWeek = startOfWeek.daysBetween(dateParam);
        result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
        return result;
    } 
}