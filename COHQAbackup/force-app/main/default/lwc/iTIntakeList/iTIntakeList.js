import { LightningElement, track, wire } from 'lwc';
import searchITIntake from '@salesforce/apex/ITIntakeTPOProjectPortfolioAuraEnabled.searchITIntake';
export default class ITIntakeList extends LightningElement {
    @track intakeRecords;
    @track errors;

    @wire(searchITIntake)
    wiredRecords({error, data}){
        console.log(' Data ', data);
        this.intakeRecords = data;
        this.errors = error;
    }

connectedCallback(){
    const eventVal = '';
    const searchMyRecordVal = true;
    console.log(' Search Param ', eventVal, searchMyRecordVal);
    searchITIntake({
        searchParam : eventVal,
        searchMyRecord : searchMyRecordVal
    })
    .then(result => {
        console.log(' IT Intake Records ', result);
        this.intakeRecords = result;
        this.errors = undefined;
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
    console.log(' Search Param handleEvent', eventVal, searchMyRecordVal);
    searchITIntake({
        searchParam : eventVal,
        searchMyRecord : searchMyRecordVal
    })
    .then(result => {
        console.log(' IT Intake Records ', result);
        this.intakeRecords = result;
        this.errors = undefined;
    })
    .catch(error => {
        console.log(' Errors ', error);
        this.errors = error;
        this.intakeRecords = undefined;
    })
}
}