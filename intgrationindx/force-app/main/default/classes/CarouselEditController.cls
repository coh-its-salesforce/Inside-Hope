public class CarouselEditController {

	public List<CarouselWrapper> lstCarouselWrapper {get;set;}
	
	public CarouselEditController() {
		lstCarouselWrapper = new List<CarouselWrapper>();
		
		List<Carousel__c> lstCarousel = [SELECT id, Name, CarouselDescription__c, CarouselTitle__c, PageLoadImage__c, Image_Attachment_Id__c, Display__c, (SELECT Id, Name, ContentType FROM Attachments) FROM Carousel__c];
		for(Carousel__c carousel : lstCarousel) {
			CarouselWrapper cw = new CarouselWrapper();
			cw.carousel = carousel;
			cw.isSelected = false;
			for(Attachment att : carousel.Attachments) {
				cw.imageName = att.Name;
				break;				
			}
			lstCarouselWrapper.add(cw);
		}
	}
	
	/*
    *   Name: customSave
    *   Description: Created new method to save carousels
    *   Date: 07/10/2015
    */
	public Pagereference customSave() {
		try {
			
			List<Carousel__c> lstCarousel = new List<Carousel__c>();
			Set<Id> imageAttIds = new Set<Id>();
			Integer photoLoadImageCount = 0;
			for(CarouselWrapper cw : lstCarouselWrapper) {
				if(cw.carousel.PageLoadImage__c) {
					photoLoadImageCount++;
				}
				if(photoLoadImageCount > 1) {
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Only one carousel can be marked as active at a time.'));
					return null;
				}
				if(cw.carousel.Image_Attachment_Id__c != null) {
					imageAttIds.add(cw.carousel.Image_Attachment_Id__c);
				}
			}
            
            if(photoLoadImageCount == 0) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'At least one carousel should be marked as active.'));
				return null;
            }
            
			Map<Id, Attachment> mapAtt = new Map<Id, Attachment>([SELECT Id, Name, Body FROM Attachment where Id = :imageAttIds]);
			List<Attachment> lstAttachment = new List<Attachment>();
			Map<String, Attachment> mapAttWithCarousel = new Map<String, Attachment>(); 
			for(CarouselWrapper cw : lstCarouselWrapper) {
				if(cw.imageName != null && cw.imageContent != null) {
					if(cw.carousel.Image_Attachment_Id__c != null && mapAtt.containsKey(cw.carousel.Image_Attachment_Id__c)) {
						Attachment att = mapAtt.get(cw.carousel.Image_Attachment_Id__c);
						att.Name = cw.imageName;
						att.Body = cw.imageContent;
                        att.ContentType = 'image';
                        //system.debug('na.newsAnnouncement : '+na.newsAnnouncement);
						//att.ParentId = na.newsAnnouncement.Id;
					} else {
						Attachment att1 = new Attachment();
						att1.Name = cw.imageName;
						att1.Body = cw.imageContent;
                        att1.ContentType = 'image';
						//att1.ParentId = na.newsAnnouncement.Id;
						//lstAttachment.add(att1);
						mapAttWithCarousel.put(cw.carousel.CarouselTitle__c, att1);
					}
				}
				lstCarousel.add(cw.carousel);
			}
			upsert lstCarousel;
			for(Carousel__c car : lstCarousel) {
				if(car.CarouselTitle__c != null && mapAttWithCarousel.containsKey(car.CarouselTitle__c)) {
					Attachment a = mapAttWithCarousel.get(car.CarouselTitle__c);
					a.ParentId = car.Id;
					lstAttachment.add(a);
				}
			}
			lstAttachment.addAll(mapAtt.values());
			upsert lstAttachment;
			
		} catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
		return new Pagereference('/apex/COH_SIRP_HOME_PAGE');
	}
	
	/*
    *   Name: customDelete
    *   Description: Created new method to delete selected carousels
    *   Date: 25/09/2015
    */
	public Pagereference customDelete() {
		List<Carousel__c> tempList = new List<Carousel__c>();
        boolean flag = false;  
        for(CarouselWrapper ca : lstCarouselWrapper) {
            if(ca.isSelected) {
                flag = true;
                if(ca.carousel.Id != null) {
                	tempList.add(ca.carousel);
                }
            }
        }
        if(!tempList.isEmpty()) {
            delete tempList;
        } else if(!flag) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'There is no row selected to remove.'));
            return null;
        }
        Pagereference ref = new Pagereference('/apex/CarouselEditPage');
		ref.setRedirect(true);
        return ref;
	}
	
	/*
    *   Name: addCarousel
    *   Description: Created new method to add new Carousels
    *   Date: 06/10/2015
    */
	public void addCarousel() {
		lstCarouselWrapper.add(new CarouselWrapper());
	}
    
    /*
    *   Name: cancel
    *   Description: Created new method to cancel carousel editing
    *   Date: 25/09/2015
    */
	public Pagereference cancel() {
		return new Pagereference('/apex/COH_SIRP_HOME_PAGE');		
	}
	
	/*
    *   Name: CarouselWrapper
    *   Description: Created Wrapper class to manage Carousels
    *   Date: 06/10/2015
    */
	public class CarouselWrapper {
		
		public Carousel__c carousel {get;set;}
		public String imageName {get;set;}
		public transient Blob imageContent {get;set;}
		public boolean isSelected {get;set;}
		
		public CarouselWrapper() {
            carousel = new Carousel__c();
            isSelected = false;
        }
	}
}