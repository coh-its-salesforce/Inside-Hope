/*
 * This trigger processes FeedItem objects for the COH Blue Pencil application
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
trigger COH_BP_FeedItemTrigger on FeedItem (before insert, before update) {

	COH_BP_FeedItemHelper.processNewFeedItems(Trigger.new);
}