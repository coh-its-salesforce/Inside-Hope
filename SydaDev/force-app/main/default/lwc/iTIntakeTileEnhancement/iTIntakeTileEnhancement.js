import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ITIntakeTile extends NavigationMixin(LightningElement) {
    @api intakeRecords;
    handleOpenRecordDetail(evt){
        this.ITIntakeRecordReference = {
                    type: 'standard__recordPage',
                    attributes: {
                        actionName: "view",
                        recordId: this.intakeRecords.Id,
                        objectApiName: "TPO_Project_Portfolio__c",
                    }
                };
                console.debug("intakeRecords Id = ", this.intakeRecords.Id);
        
        this[NavigationMixin.GenerateUrl](this.ITIntakeRecordReference)
            .then(url => this.url = url);
    
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.ITIntakeRecordReference);
        }
}