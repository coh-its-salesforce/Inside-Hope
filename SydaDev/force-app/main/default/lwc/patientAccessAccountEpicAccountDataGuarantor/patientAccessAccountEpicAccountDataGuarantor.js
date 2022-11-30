import { LightningElement, wire, api, track } from 'lwc';
import getSingleEpicAccountData from '@salesforce/apex/PatientAccessEpicAccountController.getEpicAccountData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class PatientAccessAccountEpicAccountDataGuarantor extends LightningElement {
    @api recordId;
    @api objectApi = 'Epic_Account_Data__c';
    @api record;
    @api error;
    @api epicAccountDataId;
    @api name;
    @api isLoading;
    @api AccountMRN;

    connectedCallback(){
        this.isLoading = true;
        getSingleEpicAccountData({accountId:this.recordId})
        .then(result=>{
            console.log('created....', result);
            this.record = result;
            console.log('this.record: ' + this.record);
            this.epicAccountDataId = this.record.Id;
            console.log('this.epicAccountDataId :' + this.epicAccountDataId);
            this.AccountMRN = this.record.Account_MRN_Formula__c;
            console.log('this.AccountMRN : '+ this.AccountMRN);
        })
        .catch(error=>{
            console.log('Error', error);
        })
        this.isLoading = false;
    }

    handleSubmit(){
        this.isLoading = true;
    }

    handleSuccessGuarantor1(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Guarantor 1 Save Successful',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
    }

    handleSuccessGuarantor2(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Guarantor 2 Save Successful',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
    }   
}