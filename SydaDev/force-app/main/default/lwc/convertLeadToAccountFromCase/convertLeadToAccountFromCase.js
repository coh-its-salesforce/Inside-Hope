import { LightningElement,api } from 'lwc';
import convertLead from '@salesforce/apex/COH_LeadCaseCreation.convertLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class ConvertLeadToAccountFromCase extends LightningElement {

    isServer = false;
    @api recordId;

    handleConvertlead(){
        console.log('CALLED')
        this.isServer = true;
        convertLead({
            recordId : this.recordId
        })
        .then(results=>{
            console.log('results',results);
            this.isServer = false;
            location.reload();
            this.throwSuccessToast('Converted Successfully');
        }).catch(error=>{
            console.log('error',error)
            this.isServer = false;
            this.throwErrorToast(error.body.message)
        });

    }

    throwSuccessToast(success){
        const event = new ShowToastEvent({
            title : 'Success',
            variant : 'success',
            message : success,
            mode:'sticky'
        });
        this.dispatchEvent(event);
    }

    throwErrorToast(error){
        const event = new ShowToastEvent({
            title : 'Error',
            variant : 'error',
            message : error,
            mode:'sticky'
        });
        this.dispatchEvent(event);
    }

}