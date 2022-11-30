trigger CarouselBeforeInsertUpdate on Carousel__c (Before insert, before update) {
    List<Carousel__c> carList = [select id, PageLoadImage__c from Carousel__c Where PageLoadImage__c = true];
    Integer count = 0;
        if(carList!=null && carList.size()>0){
            for(Carousel__c cs: Trigger.New){
                if((Trigger.isInsert && cs.PageLoadImage__c == true) || (Trigger.isUpdate && cs.PageLoadImage__c == true && carList[0].Id != cs.Id)){
                    cs.PageLoadImage__c.addError('Multiple carousel can not appear on page load. Please uncheck this checkbox');
                }
            }
        }else{
            for(Carousel__c cs:Trigger.new){
                if(cs.PageLoadImage__c){
                    count++;
                }
                if(count>1){
                    cs.PageLoadImage__c.addError('Multiple carousel can not appear on page load. Please uncheck this checkbox');
                }
            }
        }
}