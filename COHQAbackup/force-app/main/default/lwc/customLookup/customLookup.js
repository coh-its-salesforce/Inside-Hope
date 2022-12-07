import lookUp from '@salesforce/apex/Lookup.search';
import getDataFromAccount from '@salesforce/apex/Lookup.getDataFromAccount';
import getDataFromContact from '@salesforce/apex/Lookup.getDataFromContact';

import { api, LightningElement, track, wire } from 'lwc';


export default class customLookUp extends LightningElement {

    @api objName;
    @api iconName;
    @api filter = '';
    @api searchPlaceholder='Search';
    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;
    @api getDataFromId;
    accountRecord='';
    contactRecord='';
    searchTerm;
     @api handleValueChange() {
         console.log('isValueSelected'+this.isValueSelected);
   this.isValueSelected = false;
  }
 @api onSetData(getDataFromId) {

      console.log('testing=----'+getDataFromId);
            getDataFromAccount({ getDataFromId: getDataFromId })
            //.then(() => alert("record created"))
            .then(result => {
            this.accountRecord = result;
            if(result!=null){
                let selectedId =  this.accountRecord.Id;
                let selectedName = this.accountRecord.Name;
                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
                this.dispatchEvent(valueSelectedEvent);
                this.isValueSelected = true;
                this.selectedName = selectedName;
                    console.log('result : ' + JSON.stringify(this.data));
            }

            })
            .catch((error) => alert("error: " + JSON.stringify(error)));

        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

 }
  @api onSetOriginalDocData(getDocFromId) {

      console.log('testingcontact=----'+getDocFromId);
        getDataFromContact({ getDocFromId: getDocFromId })
        .then(result => {
            this.contactRecord = result;
            console.log('result contactRecord',result)
            if(result){
                let selectedId =  this.contactRecord.Id;
                let selectedName = this.contactRecord.Name;
                //console.log('contactRecord : ' + JSON.stringify(this.contactRecord));
                const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
                this.dispatchEvent(valueSelectedEvent);
                this.isValueSelected = true;
                this.selectedName = selectedName;
            }
                console.log('result : ' + JSON.stringify(this.selectedName));

        })
        .catch((error) => {
            console.log('ERROR',error)
           // alert("error: " + JSON.stringify(error))
        });

        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

 }
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    @wire(lookUp, {searchTerm : '$searchTerm', myObject : '$objName', filter : '$filter'})
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }
    
    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }
   

    handleRemovePill() {
        this.isValueSelected = false;
     const removeEvent = new CustomEvent('removedvalue', {detail:  this.objName });
        this.dispatchEvent(removeEvent);
    }
      @api setInputValid() {

        let inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
            }
        });
    }
    @api hideInputValid(){

        let inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(inputField => {
            inputField.setCustomValidity('');
        });
    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }

}