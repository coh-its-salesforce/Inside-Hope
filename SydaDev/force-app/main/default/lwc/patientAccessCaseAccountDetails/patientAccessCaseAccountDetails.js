import { LightningElement, wire, api, track } from 'lwc';
import getSingleAccountData from '@salesforce/apex/PatientAccessCaseAccountController.getAccountData';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class PatientAccessCaseAccountDetails extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApi = 'Account';
    @api record;
    @api error;
    @api AccountId;
    @api name;
    @api isLoading;
    @api showEdit;
    @track hasRendered = true;

    connectedCallback(){
        this.isLoading = true;
        this.showEdit = false;    
        getSingleAccountData({caseId:this.recordId})
        .then(result=>{
            console.log('created....', result);
            this.record = result;
            this.AccountId = this.record.Id;
            this.isLoading = false;
        })
        .catch(error=>{
            console.log('Error', error);
        })

    }
        
    
    handleSubmit(){
        this.isLoading = true;
    }
    handleShowEdit(){
        this.showEdit = true;
    }

    handleCancel(){
        this.showEdit = false;
    }

    handleSuccessAccount(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Account Details Saved Successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
        this.showEdit = false;
    } 
    handleNavigatetoAccount(evt){
        this.AccountRecordReference = {
            type: 'standard__recordPage',
            attributes: {
                actionName: "view",
                recordId: this.AccountId,
                objectApiName: "Account",
            }
        };
            this[NavigationMixin.GenerateUrl](this.AccountRecordReference)
            .then(url => this.url = url);
    
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.AccountRecordReference);
    }
}