/**
 *
 * Helper class that makes it easier to do common operations with the classes in the ConnectApi namespace.
 *
 * Includes convenience methods to:
 *
 *     - Post Chatter @-mentions with Apex code.
 *     - Take a feed item or comment body and return an input body that matches it.
 *       This is useful for when you retrieve a feed item or comment and want to either
 *       re-post or edit it.
 *
 * This class works with API version 32.0 and later. There is a separate class
 * that works with v31.0 and earlier.
 *
 *
 */

global class ConnectApiHelper {

    public class InvalidParameterException extends Exception {}

    /**
     * Posts a feed item with @-mentions using an @-mention formatting syntax.
     * 
     * @param communityId Use either the ID of a community, 'internal', or null.
     * @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
     * @param textWithMentions The text of the post. You can @-mention a user or group by using
     *                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
     *                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
     *                         automatically parsed if provided.
     * @return The posted feed item.
     */
    public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions) {

        if (textWithMentions == null || textWithMentions.trim().length() == 0) {
            throw new InvalidParameterException('The textWithMentions parameter must be non-empty.');
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(textWithMentions);

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = messageInput;
        input.subjectId = subjectId;
        
        return ConnectApi.ChatterFeeds.postFeedElement(communityId, input, null);
    }

    /**
     * Posts a comment with @-mentions using an @-mention formatting syntax.
     * 
     * @param communityId Use either the ID of a community, 'internal', or null.
     * @param feedItemId The ID of the feed item being commented on.
     * @param textWithMentions The text of the comment. You can @-mention a user or group by using
     *                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
     *                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
     *                         automatically parsed if provided.
     * @return The posted comment.
     */
    public static ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions) {

        if (textWithMentions == null || textWithMentions.trim().length() == 0) {
            throw new InvalidParameterException('The textWithMentions parameter must be non-empty.');
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(textWithMentions);

        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        input.body = messageInput;
        
        return ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedItemId, input, null);
    }

    public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) {
        if (inputText == null) {
            throw new InvalidParameterException('The inputText parameter cannot be null.');
        }

        List<ConnectApi.MessageSegmentInput> messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
        Integer strPos = 0;
        Pattern myPattern = Pattern.compile('\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\}'); // Match a 15 or 18 character ID surrounded by {}.
        Matcher myMatcher = myPattern.matcher(inputText);
        
        while (myMatcher.find()) {
              String textSegment = inputText.substring(strPos, myMatcher.start());
              String mentionId = myMatcher.group();
              // Strip off the { and }.
              mentionId = mentionId.substring(1, mentionId.length() - 1);
              strPos = myMatcher.end();
              
              if (textSegment != null && textSegment.length() > 0) {
                  ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(textSegment);
                  messageSegmentInputs.add(textSegmentInput);
              }
              
              ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(mentionId);
              messageSegmentInputs.add(mentionSegmentInput);
        }

        // Take care of any text that comes after the last mention.
        if (strPos < inputText.length()) {
            String trailingText = inputText.substring(strPos, inputText.length());
            if (trailingText != null && trailingText.length() > 0) {
                ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(trailingText);
                messageSegmentInputs.add(textSegmentInput);
            }
        }

        return messageSegmentInputs;
    }

    private static ConnectApi.TextSegmentInput makeTextSegmentInput(String text) {
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        return textSegment;
    }
    
    private static ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) {
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = mentionId;
        return mentionSegment;
    }
    
    /**
     * Takes an output feed body and returns a message body input that matches it.
     * This is useful for when you retrieve a feed item or comment and want to either re-post or edit it.
     */
    public static ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput input = new ConnectApi.MessageBodyInput();
        input.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        for (ConnectApi.MessageSegment segment : body.messageSegments) {
            if (segment instanceof ConnectApi.TextSegment) {
                ConnectApi.TextSegment textOutput = (ConnectApi.TextSegment) segment;
                ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
                textInput.text = textOutput.text;
                input.messageSegments.add(textInput);
            }
            else if (segment instanceof ConnectApi.MentionSegment) {
                ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) segment;
                ConnectApi.MentionSegmentInput mentionInput = new ConnectApi.MentionSegmentInput();
                mentionInput.id = mentionOutput.record.id;
                input.messageSegments.add(mentionInput);
            }
            else if (segment instanceof ConnectApi.HashtagSegment) {
                ConnectApi.HashtagSegment hashtagOutput = (ConnectApi.HashtagSegment) segment;
                ConnectApi.HashtagSegmentInput hashtagInput = new ConnectApi.HashtagSegmentInput();
                hashtagInput.tag = hashtagOutput.tag;
                input.messageSegments.add(hashtagInput);
            }
            else if (segment instanceof ConnectApi.LinkSegment) {
                ConnectApi.LinkSegment linkOutput = (ConnectApi.LinkSegment) segment;
                ConnectApi.LinkSegmentInput linkInput = new ConnectApi.LinkSegmentInput();
                linkInput.url = linkOutput.url;
                input.messageSegments.add(linkInput);
            }
            else {
                // The other segment types are system-generated and have no corresponding input types.
            }
            
        }
        return input;
    }
    
    /**
     * Takes an output body and returns a feed item input body that matches it.
     * This is useful for when you retrieve a feed item and want to either re-post or edit it.
     */
    public static ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
        
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = bodyInput;
        return input;
    }
    
    /**
     * Takes an output body and returns a comment input body that matches it.
     * This is useful for when you retrieve a comment and want to either re-post or edit it.
     */
    public static ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body) {
        ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
        
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();
        input.body = bodyInput;
        return input;
    }
    
    public Static ConnectApi.FeedItemInput parseChatterPostWithMentions(String msg){
 
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();     
         
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
         
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
     
        //parse @[User Name]
        //use pattern matching group ()  so we can easily extract name later*
        Pattern p = Pattern.compile('\\@\\[([a-z|A-Z|0-9].*?)\\]\\(\\:.*?\\)'); 
     
        //use regex to split all all non-mentions into segments
        String [] textSegments = p.split(msg,-1);
        system.debug('===textSegments=='+textSegments);
        //create a pattern matcher object
        Matcher pm = p.matcher( msg );
        system.debug('====pm===='+pm);
        //all @[mentions] in order (we will need this to build the segments later**)
        List<String> mentionedNames = new List<String>{};   
     
        Map<String,ConnectApi.MentionSegmentInput> nameToInputMap = new Map<String,ConnectApi.MentionSegmentInput>{};
     
        //iterate through each @mention and build a map of unique @mentions 
        if( pm.find()){
            
            do {
                
                //now we can extract the pattern matching group defined earlier*
                String mentionName = pm.group(1);
                //use lowercase to ensure case neutrality later***
                system.debug('====mentionName===='+mentionName);
                String rawMatch = msg.substring(pm.start(),pm.end());
                
                
                system.debug('===rawMatch=='+rawMatch);
                String lcName = mentionName.toLowerCase();
                String entId = rawMatch.substring(rawMatch.indexOf('(:')+2 , rawMatch.indexOf('(:')+ 17);
                system.debug('----entId-----'+entId);
                if(!nameToInputMap.containsKey(lcName)){
                    ConnectApi.MentionSegmentInput msi = new ConnectApi.MentionSegmentInput();
                    msi.id = entId;
                    nameToInputMap.put(lcName, msi);               
                }
                mentionedNames.add(lcName);
            } while(pm.find());
     
        }
        /*
        ConnectApi.MentionSegmentInput[] mentions = new ConnectApi.MentionSegmentInput[]{};
        
        //check the @[chatter names] against user Names
        for(User u: [SELECT Id, Name FROM User WHERE name IN: mentionedNames]){
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            //making sure to fetch using lowercased name***
            nameToInputMap.get(u.Name.toLowerCase()).id = u.id;
            mentionSegmentInput.id = u.id;   
        }
     
        //check the @[chatter names] against Chatter group Names (aka CollaborationGroup)
        for(CollaborationGroup cg: [SELECT Id, Name FROM CollaborationGroup WHERE name IN: mentionedNames]){
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            //making sure to fetch using lowercased name***
            nameToInputMap.get(cg.Name.toLowerCase()).id = cg.id;
            mentionSegmentInput.id = cg.id;  
        }
       */
        //shuffle the mentions back in with the text segments
        for(Integer i=0;i<textSegments.size();i++){
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = textSegments[i];
            messageBodyInput.messageSegments.add(textSegmentInput);
            //due to splitting, there should always be one less mention than text segments
            if(mentionedNames.size() > i){
                // now "sandwich" the @mentions into the text Segments in their original order
                messageBodyInput.messageSegments.add(nameToInputMap.get(mentionedNames[i]));
            }
        }
     
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
         
        return feedItemInput;
     
    }
        
}