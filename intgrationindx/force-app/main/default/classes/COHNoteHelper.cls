/*
 * This class contains the methods for handling trigger events for Note objects.
 * 
 * Raymond Tam
 * City of Hope
 * Copyright (c) 2017
 * 
 * No portion of this code may be copied, transferred, or transmitted
 * in any form (written, electronic, or otherwise) without the prior
 * written consent from the City of Hope.
 *  
 */
public class COHNoteHelper {

	private static final String ACCOUNT = 'Account';
    
    private static final Integer TRIGGER_NEW = 0;
    private static final Integer TRIGGER_OLD = 1;
    
    /*
     * Process Note objects.
     * 
     */
    public static void processNotes() {
        if (Trigger.isExecuting) {
            if (Trigger.isAfter && Trigger.isInsert) {
                // Accounts
                List<Note> accountNoteList = getNotes(ACCOUNT, TRIGGER_NEW);
                if (COHUtil.isValidList(accountNoteList)) {
                    COHNoteUtility.processAccountNotes(accountNoteList);
                }
            }
            // Add support for other parent object types as necessary
        }
    }
    
    /*
     * Creates a list of notes where the parent has a specific name
     * from the appropriate trigger objects.
     * 
     * @param parentObjectName	Name of parent object.
     * @param triggerType		Type of trigger.
     * @return					List of notes for the object and trigger type.
     * 
     */
    private static List<Note> getNotes(String parentObjectName, Integer triggerType) {
        List<Note> noteObjList = null;
        if (COHUtil.isValidStr(parentObjectName)) {
            noteObjList = new List<Note>();
            List<Note> noteObjSourceList;
            if (triggerType == TRIGGER_NEW) {
                noteObjSourceList = (List<Note>) Trigger.new;
//            } else if (triggerType == TRIGGER_OLD) {			// restore when Trigger.old is needed
//                noteObjSourceList = (List<Note>) Trigger.old;
            } else {
                throw new COHException('Unknown triggerType encountered in COHNoteHelper: ' + triggerType + ', parentObjectName: ' + parentObjectName);
            }
            
            for(Note noteObject : noteObjSourceList) {
                Id parentID = noteObject.ParentId;
                String currentParentObjectName = COHUtil.getObjectName(parentID);
                if (parentObjectName.equalsIgnoreCase(currentParentObjectName)) {
                    noteObjList.add(noteObject);
                }
            }
        }
        return noteObjList;
    }
}