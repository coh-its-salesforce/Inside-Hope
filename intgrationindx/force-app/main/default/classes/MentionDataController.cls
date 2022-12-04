public with sharing class MentionDataController {
    
    
    public string getjsonString (){
        string query = Apexpages.currentpage().getparameters().get('q');
        ConnectApi.MentionCompletionPage g = ConnectApi.Mentions.getMentionCompletions(Network.getNetworkId(),query,null);
        List<MentionWrapper> mentionList = new List<MentionWrapper>();
        for(ConnectAPI.MentionCompletion mc: g.mentionCompletions){
            MentionWrapper mw = new MentionWrapper();
            mw.id = mc.recordId;
            mw.Name = mc.name ;
            mw.avatar = mc.photoUrl ;
            mw.icon = '';
            mentionList.add(mw);
        }
        
        return JSON.serialize(mentionList);
    }
    public class MentionWrapper {
        public string id ;
        public string name ;
        public string avatar ;
        public string icon ;
        public string type ;
    }
}