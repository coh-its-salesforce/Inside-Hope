import { LightningElement, api, track, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import uId from '@salesforce/user/Id';
import getUserIds from '@salesforce/apex/COHCaseInsuranceTabController.getUserIds';
import getPhysicianId from '@salesforce/apex/COHCaseInsuranceTabController.getPhysicianID'; 


export default class PatientAccessPhysicianDecisionTile extends NavigationMixin(LightningElement) {
    @track UserId;
    @api recPhysicianMatrix;
    @api locationvalue;
    @api departmentvalue;
    @api servicelinevalue;
    @api specialtyvalue;
    @api physicianvalue;
    @api physicianid;
    @api distanceMapData;
    
    @track isButtonDisabled = true; 
    
    @wire(getUserIds, {}) 
    userData({ error, data }) {
        this.UserId = uId;
        if(data) {
            for ( var i = 0; i < data.length; i++ ) {
        
                    if(data[i] === this.UserId) {    
                    this.isButtonDisabled = false;
                     }
                }
        } else if(error) {
            // error handling
            console.error(error.body.message);
        }
    }
    handleOpenRecordDetail(evt){
        this.PhysicianMatrixRecordReference = {
                    type: 'standard__recordPage',
                    attributes: {
                        actionName: "view",
                        recordId: this.recPhysicianMatrix.Id,
                        objectApiName: "Physician_Matrix__c",
                    }
                };
        
        this[NavigationMixin.GenerateUrl](this.PhysicianMatrixRecordReference)
            .then(url => this.url = url);
    
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.PhysicianMatrixRecordReference);
        }

        handleSendToPhysicianMatrix(){
            var location = '';
            var department = '';
            var serviceline = '';
            var specialty = '';
            var physician = '';

            location = this.recPhysicianMatrix.Location__c;
            department = this.recPhysicianMatrix.Department__c;
            serviceline = this.recPhysicianMatrix.Service_Line__c;
            specialty = this.recPhysicianMatrix.Specialty_Diagnosis__c;
            physician = this.recPhysicianMatrix.Provider__c;

            this.locationvalue = location;
            this.departmentvalue = department;
            this.servicelinevalue = serviceline;
            this.specialtyvalue = specialty;
            this.physicianvalue = physician;

            getPhysicianId({
                physicianStr:this.physicianvalue,
            })
            .then(result =>{
                this.physicianid = result;
                this.errors = undefined;
            })
            .catch(error =>{
                console.log(' Errors ', error);
                this.errors = error;
                this.physicianid = undefined;
            })    

            const searchEvent = new CustomEvent('update',{
                detail : {
                    location: this.locationvalue,
                    department: this.departmentvalue,
                    serviceline: this.servicelinevalue,
                    specialty: this.specialtyvalue,
                    physician: this.physicianvalue,
                    physicianid: this.physicianid,
                }
            });
            this.dispatchEvent(searchEvent);
        }
    }