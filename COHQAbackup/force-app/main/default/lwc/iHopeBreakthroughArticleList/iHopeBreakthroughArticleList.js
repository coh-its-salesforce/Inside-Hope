import { LightningElement, wire, track,api } from 'lwc';
import searchBreakthrough from '@salesforce/apex/iHopeBreakthroughArticles.breakthroughArticles';


export default class IHopeBreakthroughArticleList extends LightningElement {
    @track breakthroughRecords;
    @track errors;
    @api numberofRecords;
    @api width;
    @api height;
    @api imageWidth;
    @api fontSize;

    @wire(searchBreakthrough)
    wiredRecords({error, data}){
        console.log(' Data ', data);
        this.breakthroughRecords = data;
        this.errors = error;
    }

    get widthComponent(){
        return 'width: ' + this.width +'px; background:#0072CE;text-align:center;color:white;';
    }
    get widthDetailComponent(){
        return 'height:' + this.height + 'px; background:#ffffff;border:0.5px solid black;';
    }


connectedCallback(){
    var eventVal = '';
    var numberofRecords1 = this.numberofRecords;
    console.log(' Search Param ', eventVal,numberofRecords1);
    searchBreakthrough({
        searchBreakthrough : '',
        numberofRecords : numberofRecords1
    })
    .then(result => {
        console.log(' Breakthrough records ', result);
        this.breakthroughRecords = result;
        this.errros = undefined;
    })
    .catch(error => {
        console.log(' Errors ', error);
        this.errors = error;
        this.breakthroughRecords = undefined;
    })
}

handleEvent(event){
    var eventVal = '';
    eventVal = event.detail.param;
    searchMyRecordVal = event.detail.booCheckbox;
    console.log(' Search Param HandleEvent', eventVal, searchMyRecordVal);
    searchBreakthrough({
        searchBreakthrough : '',
        numberofRecords : numberofRecords1
    })
    .then(result => {
        console.log(' Breakthrough Records ', result);
        this.breakthroughRecords = result;
        this.errros = undefined;
    })
    .catch(error => {
        console.log(' Errors ', error);
        this.errors = error;
        this.breakthroughRecords = undefined;
    })
}
}