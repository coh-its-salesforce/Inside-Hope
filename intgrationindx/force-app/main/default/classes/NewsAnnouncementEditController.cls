public with sharing class NewsAnnouncementEditController {

	public List<NewsAnnouncementWrapper> lstNewsAnnouncementWrapper {get;set;}
	public String departmentId;
    public boolean isHomePage {get;set;}
	public NewsAnnouncementEditController() {
		
		departmentId = ApexPages.currentPage().getParameters().get('id');
		lstNewsAnnouncementWrapper = new List<NewsAnnouncementWrapper>();
		
        if(departmentId != null) {
            isHomePage = false;
        } else {
            isHomePage = true;
        }
		Set<Id> imageAttIds = new Set<Id>();
		
		List<COH_SI_NewsandAnnouncement__c> lstNewsAnnouncement;
		
		if(isHomePage) {
		
			lstNewsAnnouncement = [SELECT id, name, Description__c, Title__c, Org_Wide__c, Department__c, Display__c, Image_Attachment_Id__c 
									FROM COH_SI_NewsandAnnouncement__c ORDER BY CreatedDate DESC];
		} else {
			lstNewsAnnouncement = [SELECT id, name, Description__c, Title__c, Department__c, Display__c, 
					Image_Attachment_Id__c FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = false and 
					News_Type__c != 'Department Spotlight' and Secondary_Department__c != null and 
					Secondary_Department__c = :departmentId ORDER BY CreatedDate DESC];
									
			if(departmentId != null && String.valueOf(departmentId).startsWith(Label.Department_Object_Id)) {	
				lstNewsAnnouncement = [SELECT id, name, Description__c, Title__c, Department__c, Display__c, Image_Attachment_Id__c 
									FROM COH_SI_NewsandAnnouncement__c where Org_Wide__c = false and News_Type__c != 'Department Spotlight' 
									and Department__c != null and Department__c = :departmentId ORDER BY CreatedDate DESC];
			}
		}
									
		for(COH_SI_NewsandAnnouncement__c na : lstNewsAnnouncement) {
			imageAttIds.add(na.Image_Attachment_Id__c);
		}
		Map<Id, Attachment> mapAtt = new Map<Id, Attachment>([SELECT Id, Name, Body FROM Attachment where Id = :imageAttIds]);
		for(COH_SI_NewsandAnnouncement__c na : lstNewsAnnouncement) {
			NewsAnnouncementWrapper naWrapper = new NewsAnnouncementWrapper(departmentId);
			if(na.Image_Attachment_Id__c != null) {
				naWrapper.imageName = mapAtt.get(na.Image_Attachment_Id__c).Name;
			}
			naWrapper.newsAnnouncement = na;
			lstNewsAnnouncementWrapper.add(naWrapper);
		}
	}
	
	/*
    *   Name: addNewsAnnouncement
    *   Description: Created new method to add new news and announcement
    *   Date: 25/09/2015
    */
	public void addNewsAnnouncement() {
		lstNewsAnnouncementWrapper.add(new NewsAnnouncementWrapper(departmentId));
	}
	
	/*
    *   Name: customSave
    *   Description: Created new method to save news and announcement
    *   Date: 25/09/2015
    */
	public Pagereference customSave() {
		try {
			List<COH_SI_NewsandAnnouncement__c> lstNewsAnnouncement = new List<COH_SI_NewsandAnnouncement__c>();
			Set<Id> imageAttIds = new Set<Id>();
			for(NewsAnnouncementWrapper na : lstNewsAnnouncementWrapper) {
				if(na.newsAnnouncement.Image_Attachment_Id__c != null) {
					imageAttIds.add(na.newsAnnouncement.Image_Attachment_Id__c);
				}
			}
			Map<Id, Attachment> mapAtt = new Map<Id, Attachment>([SELECT Id, Name, Body FROM Attachment where Id = :imageAttIds]);
			List<Attachment> lstAttachment = new List<Attachment>();
			Map<String, Attachment> mapAttWithNewAnnouncement = new Map<String, Attachment>(); 
			for(NewsAnnouncementWrapper na : lstNewsAnnouncementWrapper) {
				if(na.imageName != null && na.imageContent != null) {
					if(na.newsAnnouncement.Image_Attachment_Id__c != null && mapAtt.containsKey(na.newsAnnouncement.Image_Attachment_Id__c)) {
						Attachment att = mapAtt.get(na.newsAnnouncement.Image_Attachment_Id__c);
						att.Name = na.imageName;
						att.Body = na.imageContent;
                        //system.debug('na.newsAnnouncement : '+na.newsAnnouncement);
						//att.ParentId = na.newsAnnouncement.Id;
					} else {
						Attachment att1 = new Attachment();
						att1.Name = na.imageName;
						att1.Body = na.imageContent;
						//att1.ParentId = na.newsAnnouncement.Id;
						//lstAttachment.add(att1);
						mapAttWithNewAnnouncement.put(na.newsAnnouncement.Title__c, att1);
					}
				}
				lstNewsAnnouncement.add(na.newsAnnouncement);	
			}
			upsert lstNewsAnnouncement;
			for(COH_SI_NewsandAnnouncement__c coh : lstNewsAnnouncement) {
				if(coh.Title__c != null && mapAttWithNewAnnouncement.containsKey(coh.Title__c)) {
					Attachment a = mapAttWithNewAnnouncement.get(coh.Title__c);
					a.ParentId = coh.Id;
					lstAttachment.add(a);
				}
			}
			lstAttachment.addAll(mapAtt.values());
			upsert lstAttachment;
			
			
		} catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
		if(isHomePage) {
			return new Pagereference('/apex/COH_SIRP_HOME_PAGE');
		}
        if(getDepartment().Id != null && String.valueOf(getDepartment().Id).startsWith(Label.Department_Object_Id)) {
        	return new Pagereference('/apex/DepartmentPortal?id='+getDepartment().Id);
        }
        return new Pagereference('/apex/SIRP_SecondaryDepartment?id='+getSecondaryDepartment().Id+'&isSecondary=true');
	}
	
	/*
    *   Name: customDelete
    *   Description: Created new method to delete selected news and announcement
    *   Date: 25/09/2015
    */
	public Pagereference customDelete() {
		List<COH_SI_NewsandAnnouncement__c> tempNAList = new List<COH_SI_NewsandAnnouncement__c>();
        boolean flag = false;  
        for(NewsAnnouncementWrapper na : lstNewsAnnouncementWrapper) {
            if(na.isSelected) {
                flag = true;
                if(na.newsAnnouncement.Id != null) {
                	tempNAList.add(na.newsAnnouncement);
                }
            }
        }
        if(!tempNAList.isEmpty()) {
            delete tempNAList;
        } else if(!flag) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'There is no row selected to remove.'));
            return null;
        }
        Pagereference ref = new Pagereference('/apex/NewsAnnouncementEditPage?Id='+departmentId);
		if(isHomePage) {
			ref = new Pagereference('/apex/NewsAnnouncementEditPage');
		}
        ref.setRedirect(true);
        return ref;
	}
	
	/*
    *   Name: cancel
    *   Description: Created new method to cancel editing of the news and announcements
    *   Date: 25/09/2015
    */
	public Pagereference cancel() {
		if(isHomePage) {
			return new Pagereference('/apex/COH_SIRP_HOME_PAGE');
		}
		if(getDepartment().Id != null && String.valueOf(getDepartment().Id).startsWith(Label.Department_Object_Id)) {
        	return new Pagereference('/apex/DepartmentPortal?id='+getDepartment().Id);
        }
        return new Pagereference('/apex/SIRP_SecondaryDepartment?id='+getSecondaryDepartment().Id+'&isSecondary=true');
	}
	
	/*
    *   Name: getDepartment
    *   Description: Created new method to get current deparment reference
    *   Date: 25/09/2015
    */
	public Department__c getDepartment() {
		
		List<Department__c> lstDep = [Select Id, Name from Department__c where Id = :departmentId];
		if(!lstDep.isEmpty()) {
			return lstDep[0];
		}
		
		return new Department__c();
	}
	
	/*
    *   Name: getSecondaryDepartment
    *   Description: Created new method to get current secondary deparment reference
    *   Date: 25/09/2015
    */
	public Secondary_Department__c getSecondaryDepartment() {
		
		List<Secondary_Department__c> lstDep = [Select Id, Name from Secondary_Department__c where Id = :departmentId];
		if(!lstDep.isEmpty()) {
			return lstDep[0];
		}
		
		return new Secondary_Department__c();
	}
	
	/*
    *   Name: NewsAnnouncementWrapper
    *   Description: Created Wrapper class to manage news and announcements 
    *   Date: 25/09/2015
    */
	public class NewsAnnouncementWrapper {
		
		public COH_SI_NewsandAnnouncement__c newsAnnouncement {get;set;}
		public String imageName {get;set;}
		public transient Blob imageContent {get;set;}
		public boolean isSelected {get;set;}
		
		public NewsAnnouncementWrapper(Id departmentId) {
            newsAnnouncement = new COH_SI_NewsandAnnouncement__c();
            if(departmentId != null) { 
	            if(String.valueOf(departmentId).startsWith(Label.Department_Object_Id)) {
	            	system.debug('Department****');
	            	newsAnnouncement.Department__c = departmentId;	
	            } else {
	            	newsAnnouncement.Secondary_Department__c = departmentId;
	            	system.debug('Secondary Department****');
	            }
            } //else {
			//	newsAnnouncement.Org_Wide__c = true;
			//}
            isSelected = false;
        }
	}
}