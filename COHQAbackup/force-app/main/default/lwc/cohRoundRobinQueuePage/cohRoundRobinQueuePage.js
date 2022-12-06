/**
 * @description       : 
 * @author            : Sanjay
 * @group             : 
 * @last modified on  : 02-25-2021
 * @last modified by  : Sanjay
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   02-04-2021   Sanjay   Initial Version
**/
import { api, LightningElement, track, wire } from 'lwc';
import getObjectList from '@salesforce/apex/COH_RoundRobinQueuePageController.getObjectList';
import getQueues from '@salesforce/apex/COH_RoundRobinQueuePageController.getQueues';
import getQueueMembers from '@salesforce/apex/COH_RoundRobinQueuePageController.getQueueMembers';
import updateMembers from '@salesforce/apex/COH_RoundRobinQueuePageController.updateRecords';
import { getRecord, getFieldValue,deleteRecord   } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/COH_Round_Robin_Queue__c.Id';
import QUEUE_ID_FIELD from '@salesforce/schema/COH_Round_Robin_Queue__c.Queue_SF_Id__c';
import OBJECT_APINAME_FIELD from '@salesforce/schema/COH_Round_Robin_Queue__c.SObject_API_Name__c';
import ACTIVE_FIELD from '@salesforce/schema/COH_Round_Robin_Queue__c.Active__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
const ROUND_ROBIN_FIELDS = [ID_FIELD, QUEUE_ID_FIELD, OBJECT_APINAME_FIELD, ACTIVE_FIELD];
export default class CohRoundRobinQueuePage extends  NavigationMixin(LightningElement) {
    @api recordId;
    @api editable = false;

    objectList = [];
    queueList = [];

    @track avaibaleQueueMember;
    selctedObject = 'Case';
    selectedQueue ;
    isActive = false;
    loading = true;
    error;
    roundRobinRecord;
    finalMember ;

    connectedCallback(){

        if(!this.recordId) this.editable = true;
        this.loading = true;
        console.log('----called connected callback--');
        getObjectList()
        .then((data)=>{
            console.log('----resolved--');
            console.log(data)
            this.objectList = data.map((element)=>{
                console.log(element)
                return {label: element.objectLabel, value: element.apiName}
            });
            this.loading = false;
        })
        .catch((error)=>{
           this.handleError(error);
        });
    }

    @wire(getRecord, { recordId: '$recordId', fields: ROUND_ROBIN_FIELDS})
    wiredRoundRobin({data, error}){
        if(data){
            this.selctedObject = getFieldValue(data, OBJECT_APINAME_FIELD);
            this.selectedQueue = getFieldValue(data, QUEUE_ID_FIELD);
            this.isActive = getFieldValue(data, ACTIVE_FIELD);
            this.loadQueueMembers();
        }

        if(error){
            this.handleError(error);
        }
    }
   
    @wire(getQueues, { objName : '$selctedObject'})
    wiredQueueList({data, error}){
        if(data){
            this.queueList = data.map((element)=>{
                return {label: element.Name, value: element.Id}
            });
             
        }
        else if(error) {
            this.handleError(error);
           
        }
        this.loading = false;
    }
    get readOnly(){
        return !this.editable;
    }

    get isQueueListDisabled(){
        return !this.selctedObject || this.readOnly;
    }

    handleObjectChange(event){
        this.selctedObject = event.detail.value;
        this.selectedQueue = '';
        this.loading = true;
        this.avaibaleQueueMember = undefined;
    }

    handleQueueChange(event){
        this.selectedQueue = event.detail.value;
        this.loading = true;
        this.loadQueueMembers();
    }

    handleActiveChange(event){
        this.isActive = event.target.checked;
    }

    loadQueueMembers(){
        this.loading = true;
        getQueueMembers({queueId : this.selectedQueue, recordId: this.recordId})
        .then(data=>{
            console.log('received---',data);
            this.avaibaleQueueMember = data;
            this.finalMember = data.map((element)=>{
                return element;
            });
            console.log('this.finalMember---',this.finalMember);
        })
        .catch(error=>{
            this.handleError(error);
            console.error(error);
        })
        .finally(()=>{
            this.loading = false;
        });
    }

    handleCancel(){
        this.loadQueueMembers();
        this.editable = false;
    }

    handleEdit(){
        this.editable = true;
    }

    handleDelete(){
        this.loading = true;
        deleteRecord(this.recordId)
            .then(() => {
                
                this.showSuccess('Record deleted');
                // Navigate to a record home page after
                // the record is deleted, such as to the
                // contact home page
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'COH_Round_Robin_Queue__c',
                        actionName: 'home',
                    },
                });
            })
            .catch(error => {
                this.handleError(error);
                
            })
            .finally(()=>{
                this.loading = false;
            });
    }

    handleSave(event){
        this.loading = true;
        console.log('===JSON.stringify(this.finalMember)=='+JSON.stringify(this.finalMember));
        let fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId ? this.recordId : null;
        fields[QUEUE_ID_FIELD.fieldApiName] = this.selectedQueue;
        fields[OBJECT_APINAME_FIELD.fieldApiName] = this.selctedObject;
        fields[ACTIVE_FIELD.fieldApiName] = this.isActive;

        const found = this.queueList.find(element => element.value === this.selectedQueue);
        
        if(found){
            fields['Name'] = found.label;
        }
        

        updateMembers({
            roundRobinFields : JSON.stringify(fields),
            memberJSON : JSON.stringify(this.finalMember),
        })
        .then(result=>{
            
            this.showSuccess('Data saved successfully.');
            this.editable = false;
        })
        .catch(error=>{
            this.handleError(error);
            
        })
        .finally(()=>{
            this.loading = false;
        })
    }

    handleMemberChange(event){
        let record = event.detail;
        console.log('record--',record);
        this.finalMember = this.finalMember.map((element)=>{
                
            if(element.userRec.Id === record.userId){
                element.isAssociated = record.isAssociated ;
                element.order = record.order;
                element.isActive = record.isActive;
            }
            return element;
        });
        console.log('===this.finalMember=',this.finalMember);
    }

    showError(message) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSuccess(message) {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    handleError(error){
        console.error(error);
        // UI API read operations return an array of objects
        if (Array.isArray(error.body)) {
            this.error = error.body.map(e => e.message).join(', ');
        } 
        // UI API write operations, Apex read and write operations 
        // and network errors return a single object
        else if (typeof error.body.message === 'string') {
            this.error = error.body.message;
        }

        this.showError(this.error);
    }

}