import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PatientInformation extends LightningElement {

    @api recordId;
    showSpinner = false;
    ssnValue = '';
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
        
        event.preventDefault();

        if(this.isInputValid()){

            // Get data from submitted form
            const fields = event.detail.fields;
            if(!fields.COH_Account_EC_PatientAccess_MobilePhone__c && !fields.COH_Account_EC_PatientAccess_HomePhone__c && !fields.COH_Account_EC_PatientAccess_WorkPhone__c ){
                console.log('ERROR');
                const eventToast = new ShowToastEvent({
                    title: 'Error',
                    message:'Please add at least one phone number field on the Emergency contact Information ',
                    variant: 'error'

                });
                this.dispatchEvent(eventToast);
                return;
            }else{
                this.showSpinner = true;
                fields.COH_Account_PatientAccess_SSN__c = this.ssnValue;
                this.template.querySelector('lightning-record-edit-form').submit(fields);
            }
        }
    }

    handleError(event){
        this.showSpinner = false;
    }

    handleChange(event){
        this.ssnValue = event.target.value;
    }

    handleOnload(event){
        var record = event.detail.records;
        var fields = record[this.recordId].fields; // record['0010K000026Y******'].fields;
        console.log('FIELDS', JSON.parse(JSON.stringify(fields)))
        const ssn = fields.COH_Account_PatientAccess_SSN__c.value; 
        this.ssnValue = ssn;
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            //this.contact[inputField.name] = inputField.value;
        });
        return isValid;
    }
    
}