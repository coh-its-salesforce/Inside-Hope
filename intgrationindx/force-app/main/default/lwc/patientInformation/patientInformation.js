import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PatientInformation extends LightningElement {

    @api recordId;
    showSpinner = false;
    handleSuccess(event){
        console.log('SAved Successfully');
        this.showSpinner = false;
        const eventToast = new ShowToastEvent({
            title: 'Success',
            message:'Record updated Successfully',
            variant: 'success'

        });
        this.dispatchEvent(eventToast);

        const fields = event.detail.fields;
        console.log('fields',JSON.parse(JSON.stringify(fields)) );

        const selectedEvent = new CustomEvent('selfpay', { detail: fields.Self_Pay__c.value });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);

    }

    handlePrev(event){
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleSubmit(event){
        this.showSpinner = true;
    }

    handleError(event){
        this.showSpinner = false;
    }
    
}