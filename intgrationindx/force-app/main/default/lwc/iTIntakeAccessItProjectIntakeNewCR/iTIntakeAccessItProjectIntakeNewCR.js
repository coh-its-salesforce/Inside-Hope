import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const fields = [
    // This invalid field causes @wire(getRecord) to return an error
    'Contact.invalidField' 
];

export default class ITIntakeAccessItProjectIntakeNewCR extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api showForm;
    @api isLoading = false;


    handleSuccess(){
        this.showForm = false;
        this.isLoading = false;
        const event = new ShowToastEvent({
            title: 'Record Created',
            message: 'Your Change Request has been created',
        });
        this.dispatchEvent(event);
    }

    handleError(){
        this.isLoading = false;
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'The Change Request can not be created. There are values in the Original Request that need to be updated.. Please contact IT PMO'
        })
    }    

    handleSubmit(){
        this.isLoading = true;
        
    }

    handleReset(){
        this.template.querySelector('form').reset();
    }

    handleNew(){
        this.showForm = true;        
        this.isLoading = false;
        this.handleReset = true;
    }
    handleCancel(){
        this.showForm = false;
        this.isLoading = false;

    }
}