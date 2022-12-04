public class HomePageEditController {
	
    public String selectedComponent {get;set;}
	
    public HomePageEditController() {
        selectedComponent = 'NA';
    }
    
    public List<SelectOption> getComponentNames() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('NA','News & Announcement')); 
        options.add(new SelectOption('CA','Carousel')); 
        return options; 
    }
    
    public void redirectToEditPage() {
        /*if(selectedComponent == 'NA') {
            return new PageReference('/apex/NewsAnnouncementEditPage');
        }
        return new PageReference('/apex/CarouselEditPage');*/
    }
}