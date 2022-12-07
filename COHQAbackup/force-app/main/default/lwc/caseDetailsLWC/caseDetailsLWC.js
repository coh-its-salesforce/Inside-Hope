import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CaseDetailsLWC extends LightningElement {

    @api recordId;
    showContact = false;
    activeSections = ['Patient Details', 'Caller Information','Case Information','System Information'];

   
    showSuccessToast() {   
        const event = new ShowToastEvent({
            title: 'Success',
            variant: 'success',
            message:'Saved Successfully',
        });
        this.dispatchEvent(event);
    }

    handleOnLoad(event){
        var record = event.detail.records;
        var fields = record[this.recordId].fields; // record['0010K000026Y******'].fields;
        const ContactId = fields.ContactId.value; 
        if(ContactId!=null && ContactId!=undefined){
            this.showContact = true;
        }
        console.log('ContactId',ContactId)
    }

    handleSectionToggle(){

    }

    handleSuccess(event){
        console.log('SUCCESS');
        this.showSuccessToast();
    }

    handleSubmit(event){
        console.log('SUBMIT')
    }

    handleError(event){
        console.log('ERROR')
    }
}