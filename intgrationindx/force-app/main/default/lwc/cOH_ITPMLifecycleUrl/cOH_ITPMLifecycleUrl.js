import { LightningElement, api, wire } from 'lwc';
import getId from '@salesforce/apex/COH_Get_IT_PMRecords.getITPMLifecycleId'

export default class cOH_ITPMLifecycleUrl extends LightningElement {
    @api recordId;
    @api recordurl;
    @api error;

    @wire(getId, {itProjectIntakeId : '$recordId'})
    ITPMLifecycle({data,error}){
        if(data){
            this.error = undefined;
            this.recordurl = '/lightning/r/IT_Portfolio_Management__c/'+data+'/view';
            }
        if(error){
            this.error = error;
            this.record = undefined;
        }
    }
}