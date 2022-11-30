import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class PicklistWithRecordType extends LightningElement {

    @api controllingField;
    @api userDefaultRecordTypeId;
    @api objectApiName='Account';
    @api disableRecordTypeSelection;
    @api hideRecordTypeInput;
    @api controllingFieldValue;

    @api recordTypeId;
    @api controllingRequired;

    objectInfo;
    showPicklists = true;

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    handleObjectInfoWire({error, data}) {

        if(error) {
            this.handleError(error);
            return;
        }

        if(!data) {
            return;
        }

        this.objectInfo = data;
        this.initRecordTypeId();
    }

    initRecordTypeId() {

        if(!this.objectInfo) {
            return;
        }

        this.recordTypeId = this.userDefaultRecordTypeId 
            ? Object.keys(this.objectInfo.recordTypeInfos).find(rtId => rtId === this.userDefaultRecordTypeId )
            : this.defaultRecordTypeId;
    }
    
    handleControllingPicklistChange(event) {
        this.controllingFieldValue = event.detail.value;
    }

    handleError(err) {
        console.error(err);
    }

    get recordTypesList() {
        if(!this.objectInfo) {
            return;
        }

        const rtInfoList = this.objectInfo.recordTypeInfos;
        let rtList = [];
        Object.keys(this.objectInfo.recordTypeInfos).forEach(rt => {
            let rtInfo = rtInfoList[rt];
            rtInfo.master || !rtInfo.available || rtList.push(this.getRecordTypeOption(rtInfo));
        });
        return rtList;
    }

    get defaultRecordTypeId() {
        return this.objectInfo?.defaultRecordTypeId;
    }

    get showRecordTypeInput() {
        return this.recordTypeId && !this.hideRecordTypeInput;
    }
}