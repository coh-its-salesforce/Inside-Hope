import { LightningElement, track, wire } from 'lwc';
import searchEnhancement from '@salesforce/apex/ITIntakeTPOProjectPortfolioAuraEnabled.searchEnhancement';
export default class ITIntakeListEnhancement extends LightningElement {
    @track intakeRecords;
    @track errors;
    @track variable1;
    @track variable2;

    @wire(searchEnhancement)
    wiredRecords({error, data}){
        console.log(' Data ', data);
        this.intakeRecords = data;
        this.errors = error;
    }

connectedCallback(){
    var eventVal = '';
    var searchMyRecordVal = true;
    console.log(' Search Param ', eventVal, searchMyRecordVal);
    searchEnhancement({
        searchEnhancement : '',
        searchMyRecord : searchMyRecordVal
    })
    .then(result => {
        console.log(' IT Intake Records ', result);
        this.intakeRecords = result;
        this.errros = undefined;
    })
    .catch(error => {
        console.log(' Errors ', error);
        this.errors = error;
        this.intakeRecords = undefined;
    })
}

handleEvent(event){
    var eventVal = '';
    var searchMyRecordVal = true;
    eventVal = event.detail.param;
    searchMyRecordVal = event.detail.booCheckbox;
    this.variable1 = event.detail.param;
    this.variable2 = event.detail.booCheckbox;
    console.log(' Search Param HandleEvent', eventVal, searchMyRecordVal);
    searchEnhancement({
        searchEnhancement : eventVal,
        searchMyRecord : searchMyRecordVal
    })
    .then(result => {
        console.log(' IT Intake Records ', result);
        this.intakeRecords = result;
        this.errros = undefined;
    })
    .catch(error => {
        console.log(' Errors ', error);
        this.errors = error;
        this.intakeRecords = undefined;
    })
}
}