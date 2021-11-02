import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class IHopeBreakthroughArticleTile extends LightningElement {
    @api breakthroughRecords;
    @api imageWidth;
    @api imageHeight;
    @api fontSize;


    get fontComponentSize(){
        return 'font-size:' + this.fontSize + 'px;';
    }

    get imageComponentSize(){
        let actualSize=this.imageHeight - 1;
        return 'height: ' + actualSize + 'px; width: '+ this.imageWidth + 'px; float:left;';
    }

    handleOpenRecordDetail(evt){
        this.breakthroughRecordReference = {
            type: 'standard__recordPage',
            attributes: {
                actionName: "view",
                recordId: this.breakthroughRecords.Id,
                objectApiName: "Breakthrough__c",
            }
        };
        console.debug("breakthroughRecords Id = ", this.breakthroughRecords.Id);

        this[NavigationMixin.GenerateURL](this.breakthroughRecordReference)
        .then(url => this.url = url);

        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.breakthroughRecordReference);
    }
}