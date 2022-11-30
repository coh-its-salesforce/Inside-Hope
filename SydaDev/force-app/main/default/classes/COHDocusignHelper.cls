/*
 * This class contains the methods for handling trigger events for Docusign objects.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2015
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHDocusignHelper {
    /*
     * This method handles all trigger called for the Docusign object.
     * 
     */
    public static void processRecords() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isUpdate) {
                // Updates the status on completed accounts
                DCSNProcessDocusignUtil.processFieldChanges(Trigger.old, Trigger.new);
            }
        }
    }
}