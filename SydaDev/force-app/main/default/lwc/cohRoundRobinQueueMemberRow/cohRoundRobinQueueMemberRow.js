/**
 * @description       : 
 * @author            : Sanjay
 * @group             : 
 * @last modified on  : 02-19-2021
 * @last modified by  : Sanjay
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   02-05-2021   Sanjay   Initial Version
**/
import { api, LightningElement } from 'lwc';

export default class CohRoundRobinQueueMemberRow extends LightningElement {
    @api readOnly = false;
    user;
    associated = false;
    active = false;
    order ;
    @api 
    get member(){
        return this.user;
    }
    set member(value){
        this.user = value;
        this.associated = value.isAssociated;
        this.active = value.isActive;
        this.order = value.order;
    }

    
    handleChange(event){
        this.associated  =event.target.checked;
        this.fireChangeEvent();
        
    }

    handleActiveChange(event){
        this.active = event.target.checked;
        this.fireChangeEvent();
    }

    handleOrderChange(event){
        this.order = event.target.value;
        this.fireChangeEvent();
    }

   
    fireChangeEvent(){
        console.log('====user===', JSON.stringify(this.user));
        this.dispatchEvent(new CustomEvent('detailchange', {detail : {userId : this.user.userRec.Id, order: this.order, isAssociated : this.associated, isActive : this.active}}));
    }



    
    
}