import { LightningElement } from 'lwc';

export default class ITIntakeSearch extends LightningElement {
    searchBar = '';
    checkboxVal = true;
    handleChange(event){
        const field = event.target.name;
        if(field === 'searchBar'){
            this.searchBar = event.target.value;
        } else if (field === 'checkboxVal'){
            this.checkboxVal = event.target.checked;
        }
        const searchEvent = new CustomEvent('search',{
                detail : {param:this.searchBar,
                          booCheckbox:this.checkboxVal
                        }
            }
        );
        this.dispatchEvent(searchEvent);
    }
}