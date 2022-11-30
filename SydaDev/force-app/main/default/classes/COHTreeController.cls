public class COHTreeController{
    public List<TreeModel> nodeList {get;set;}
    public COHTreeController(){
        nodeList = new List<TreeModel>();
        for(BMCServiceDesk__Category__c cat : [Select Id, Name, BMCServiceDesk__FKParentCategory__c, (Select Id, Name, BMCServiceDesk__FKParentCategory__c from BMCServiceDesk__Categories__r WHERE BMCServiceDesk__inactive__c = false AND BMCServiceDesk__AvailableForIncidents__c = true ORDER BY Name) from BMCServiceDesk__Category__c WHERE BMCServiceDesk__inactive__c = false AND BMCServiceDesk__AvailableForIncidents__c = true ORDER BY Name]){
            if(cat.BMCServiceDesk__Categories__r.size() > 0){
                TreeModel tm = new TreeModel();
                tm.id = cat.Id;
                tm.parent = cat.BMCServiceDesk__FKParentCategory__c;
                tm.name = cat.name;
                for(BMCServiceDesk__Category__c child: cat.BMCServiceDesk__Categories__r){
                    TreeModel tmChild = new TreeModel();
                    tmChild.id = child.Id;
                    tmChild.parent = child.BMCServiceDesk__FKParentCategory__c;
                    tmChild.name = child.name;
                    tm.children.add(tmChild);
                }
                nodeList.add(tm);        
            }
        }
    
    }
    
    public class TreeModel{
        public string id {get;set;}
        public string parent {get; set;}
        public string name {get;set;}
        public List<TreeModel> children {get;set;}
        
        public TreeModel(){
            children  = new List<TreeModel>();
        }
    
    }
}