import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Case.Id', 'Case.Service_Category__c'];

export default class TestWire extends LightningElement {
    @api recordId;
    contact;
    name;
    phone;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.contact = data;
            console.log('output',this.contact);
            console.log('output1',data.fields.Id.value);
            console.log('output2',data.fields.Service_Category__c.value);
        }
    }
}