@isTest
private class iHopeBreakthroughArticlesTest {
    @isTest
    static void testGetArticle() {
        breakthrough__c recBreakthrough = new breakthrough__c();
        recBreakthrough.Name = 'test123';
        recBreakthrough.BlogAuthor__c = 'Test Author';
        recBreakthrough.BodyContent__c = 'Test BodyContent';
        recBreakthrough.Link_to_Full_Article__c = 'http://yahoo.com';
        recBreakthrough.TitleRTF__c = 'Test Title';
        recBreakthrough.Property__c = 'Test Property';
        recBreakthrough.MetaTitle__c = 'Test MetaTitle';
        recBreakthrough.MetaKeywords__c = 'Test MetaKeywords';
        recBreakthrough.Release_Date__c = system.Date.today();
        insert recBreakthrough;
        String queryName = recBreakthrough.Name;
        List<Breakthrough__c> queriedBreakthroughRecords = iHopeBreakthroughArticles.breakthroughArticles('','5');
        List<Breakthrough__c> nullBreakthroughRecords = iHopeBreakthroughArticles.breakthroughArticles(null,null);

    }
}