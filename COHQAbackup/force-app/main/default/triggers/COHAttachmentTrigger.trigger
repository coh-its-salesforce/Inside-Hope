/*
 * This trigger processes Attachment objects.
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
trigger COHAttachmentTrigger on Attachment (after insert, before delete) {
    COHAttachmentHelper.processAttachments();
}