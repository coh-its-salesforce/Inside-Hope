import { LightningElement, api, track, wire } from 'lwc';
import searchPhysicianMatrices from '@salesforce/apex/COHCaseInsuranceTabController.searchPhysicianMatrix';
import distancecal from '@salesforce/apex/COHCaseInsuranceTabController.getDistance';
export default class PatientAccessPhysicianDecisionList extends LightningElement {
    
    @api strRecordId;
    @api strRecordTypeId;
    @api strObjectName;
    @api inspdcc;
    /*Output Attributes*/
    @api locationvalue;
    @api departmentvalue;
    @api servicelinevalue;
    @api specialtyvalue;
    @api physicianvalue;
    @api physicianId;
    @api diagnosisNotListed; //CHANGES BY SANJAY 05/23/2022
    
    @track recPhysicianMatrix;
    @track errors;
    @track isLoading = false;


    connectedCallback(){
        var location = '';
        var department = '';
        var serviceline = '';
        var specialty = '';
        var physician = '';
        location = this.locationvalue;
        department = this.departmentvalue;
        serviceline = this.servicelinevalue;
        specialty = this.specialtyvalue;
        physician = this.physicianvalue;

        searchPhysicianMatrices({
            locationVal : location,
            department : department,
            serviceline : serviceline,
            specialty : specialty,
            physician : physician,
            caseId : this.strRecordId,
            inspdccs : this.inspdcc
        })
        .then(result => {
            this.recPhysicianMatrix = JSON.parse(result);
           // this.calculateDistance(location,result)
            this.errors = undefined;
        })
        .catch(error => {
            console.log(' Errors ', error);
            this.errors = error;
            this.recPhysicianMatrix = undefined;
        })
    }

    handleEvent(event){
        this.isLoading = true;
        var location = '';
        var department = '';
        var serviceline = '';
        var specialty = '';
        var physician = '';
        var physicianid = '';

        location = event.detail.location;
        department = event.detail.department;
        serviceline = event.detail.serviceline;
        specialty = event.detail.specialty;
        physician = event.detail.physician;
        physicianid = event.detail.physicianId;
        

        this.locationvalue = location;
        this.departmentvalue = department;
        this.servicelinevalue = serviceline;
        this.specialtyvalue = specialty;
        this.physicianvalue = physician;
        this.physicianId = physicianid;
        

        this.isLoading = true;

        searchPhysicianMatrices({
            locationVal : location,
            department : department,
            serviceline : serviceline,
            specialty : specialty,
            physician : physician,
            caseId : this.strRecordId,
            inspdccs : this.inspdcc
        })
        .then(result => {
            this.recPhysicianMatrix = JSON.parse(result);
            //this.calculateDistance(location,result)
            this.errors = undefined;
            this.isLoading = false;
        })
        .catch(error => {
            console.log(' Errors ', error);
            this.errors = error;
            this.recPhysicianMatrix = undefined;
            this.isLoading = false;
        })
    }

    calculateDistance(location,resultsData){

        distancecal({
            caseId : this.strRecordId,
            ognCity : location,
            
        })
        .then(result => {
            if(result.length>0){
            var obj = {};

            if(result[0].includes('km')){
                var dist = result[0].split(' ');
                result[0] = (parseInt(dist[0])/1.6)+' miles';
            }
            obj.distance = result[0];
            obj.time = result[1];
            this.distanceMap = obj; 
            }
             this.recPhysicianMatrix = resultsData;
            this.errros = undefined;
        })
        .catch(error => {
            console.log(' Errors ', error);
            this.errors = error;
           
        })
    }

    @api refreshInspdccValue () {
        window.setTimeout(()=> {
            this.template.querySelector('c-patient-access-physician-decision-search').refreshInspdccValue();
       },1000);
    }

    @api
    getDiagnosisNotListedValue() {
        return this.template.querySelector('c-patient-access-physician-decision-search').diagnosisNotListed;
    }

}