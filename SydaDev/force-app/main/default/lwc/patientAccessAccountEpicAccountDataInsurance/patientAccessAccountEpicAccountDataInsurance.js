import { LightningElement, wire, api, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getSingleEpicAccountData from '@salesforce/apex/PatientAccessEpicAccountController.getEpicAccountData';
import getPurchaserPlanName from '@salesforce/apex/PatientAccessEpicAccountController.getPurchaserPlanName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PURCHASERPLAN1ID__FIELD from '@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_1__c';
import PURCHASERPLAN2ID__FIELD from '@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_2__c';
import PURCHASERPLAN3ID__FIELD from '@salesforce/schema/Epic_Account_Data__c.Insurance_Purchaser_Plan_3__c';
const fields = [PURCHASERPLAN1ID__FIELD,PURCHASERPLAN2ID__FIELD,PURCHASERPLAN3ID__FIELD];

export default class PatientAccessAccountEpicAccountData extends LightningElement {
    @api recordId;
    @api objectApi = 'Epic_Account_Data__c';
    @api record;
    @api purchaserPlan1Name;
    @api error;
    @api epicAccountDataId;
    @api name;
    @api AccountMRN;
    @api isLoading = false;
    @api showPayerAddress1 = false;
    @api showPayerAddress2 = false;
    @api showPayerAddress3 = false;
    @api lookupId;
    @api rendered =false;

   @wire(getRecord,{
        recordId: '$recordId',
        fields
    })
    epicAccountData;

    get initPurchaserPlan1Id(){
        return getFieldValue(this.epicAccountData.data, PURCHASERPLAN1ID__FIELD )
    }
    get initPurchaserPlan2Id(){
        return getFieldValue(this.epicAccountData.data, PURCHASERPLAN2ID__FIELD )
    }    
    get initPurchaserPlan3Id(){
        return getFieldValue(this.epicAccountData.data, PURCHASERPLAN3ID__FIELD )
    }


    connectedCallback(){
        this.AccountMRN = true;
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
            console.log('PurchaserPlan1Name: '+ this.record.Insurance_Purchaser_Plan_1__r.Name);
            if(this.record.Insurance_Purchaser_Plan_1__r.Name.includes('GENERIC')){
                this.showPayerAddress1 = true;
            }
            if(this.record.Insurance_Purchaser_Plan_2__r.Name.includes('GENERIC')){
                this.showPayerAddress2 = true;
            }
            if(this.record.Insurance_Purchaser_Plan_3__r.Name.includes('GENERIC')){
                this.showPayerAddress3 = true;
            }  
        })
        .catch(error=>{
            console.log('Error', error);
        })
        this.isLoading = false;
    }

    handleSubmit(){
        this.isLoading = true;
    }

    handleSuccessInsurance1(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Insurance 1 Save Successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
    }

    handleSuccessInsurance2(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Insurance 2 Save Successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
    }   
    
    handleSuccessInsurance3(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Insurance 3 Save Successfully',
            variant: 'success',
        });
        this.dispatchEvent(toastEvt);
    }
    
    handleError(){
        this.isLoading = false;
        const toastEvt = new ShowToastEvent({
            title: 'Update Failed',
            variant: 'error',
        });
        this.dispatchEvent(toastEvt);
    }

    determineAddress1Visibility(event){
        this.lookupId = event.target.value;
        if(this.lookupId != null){
            getPurchaserPlanName({purchaserPlanId:this.lookupId})
            .then(result=>{
                console.log('created....', result);
                this.purchaserPlan1Name = result;
                console.log('this.purchaserPlan1Name: ' + this.purchaserPlan1Name);
                if(this.purchaserPlan1Name.includes('GENERIC')){
                    this.showPayerAddress1 = true;
                }
                if(!this.purchaserPlan1Name.includes('GENERIC')){
                    this.showPayerAddress1 = false;
                }
            })
            .catch(error=>{
                console.log('Error', error);
            })  
        }
    }

    determineAddress2Visibility(event){
        this.lookupId = event.target.value;
        if(this.lookupId != null){
            getPurchaserPlanName({purchaserPlanId:this.lookupId})
            .then(result=>{
                console.log('created....', result);
                this.purchaserPlan2Name = result;
                console.log('this.purchaserPlan2Name: ' + this.purchaserPlan2Name);
                if(this.purchaserPlan2Name.includes('GENERIC')){
                    this.showPayerAddress2 = true;
                }
                if(!this.purchaserPlan2Name.includes('GENERIC')){
                    this.showPayerAddress2 = false;
                }
            })
            .catch(error=>{
                console.log('Error', error);
            })  
        }
    }

    determineAddress3Visibility(event){
        this.lookupId = event.target.value;
        if(this.lookupId != null){
            getPurchaserPlanName({purchaserPlanId:this.lookupId})
            .then(result=>{
                console.log('created....', result);
                this.purchaserPlan3Name = result;
                console.log('this.purchaserPlan3Name: ' + this.purchaserPlan3Name);
                if(this.purchaserPlan3Name.includes('GENERIC')){
                    this.showPayerAddress3 = true;
                }
                if(!this.purchaserPlan3Name.includes('GENERIC')){
                    this.showPayerAddress3 = false;
                }
            })
            .catch(error=>{
                console.log('Error', error);
            })  
        }
    }
}