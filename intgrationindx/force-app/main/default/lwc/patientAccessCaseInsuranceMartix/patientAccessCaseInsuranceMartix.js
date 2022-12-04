import { LightningElement,api,track, wire } from 'lwc';
import { getRecord,updateRecord } from 'lightning/uiRecordApi';
import getSchedulingGuidelines from '@salesforce/apex/COHCaseInsuranceTabController.getSchedulingGuidelines';
import searchPhysicianMatrices from '@salesforce/apex/COHCaseInsuranceTabController.searchPhysicianMatrix';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SchedulingScripting from '@salesforce/label/c.SchedulingScripting';


const caseFields = [
 'Case.RecordTypeId',
 'Case.Service_Category__c',
 'Case.Health_Plan__c',
 'Case.Plan_Type__c',
 'Case.Medical_Group_IPA__c',
 'Case.Line_of_Business_Decision_Tree__c',
 'Case.Service_Line__c',
 'Case.Physician_Decision_Tree__c',
 'Case.Specialty__c',
 'Case.Physician__c',
 'Case.Auth__c',
 'Case.Location__c',
 'Case.Department__c',
 'Case.Does_patient_have_auth_at_time_of_schedu__c',
 'Case.Patient_Type__c',
 'Case.Subgroup_Num__c',
 'Case.inspdccValue__c',
 'Case.Diagnosis_Not_Listed__c' //CHANGES BY SANJAY 05/23/2022
];


export default class PatientAccessCaseInsuranceMartix extends NavigationMixin(LightningElement) {
    @api recordId;
    @track isEditEnable = false;
    @track isRequired = false;

    @track dataSet = [];
    @track isToggleOn = false;
    @track guidelinesTable = [];
    @track isToggleOnMatrix = false;
    @track inspdccValue;
    @track isSchedule = false;


    label = {
        SchedulingScripting
    };

    @wire(getRecord,{recordId:'$recordId', fields: caseFields})
    getCaseRecord({error,data}) {
        if(error){
            console.log('error',error);
        } else if(data) {
            this.dataSet = data;
            if (this.dataSet.fields.Patient_Type__c.value === 'Second Opinion on Treatment'){
                this.isSchedule = true; 
            }
            if(this.dataSet.fields.inspdccValue__c.value != null && this.dataSet.fields.inspdccValue__c.value != '') {
                this.inspdccValue = this.dataSet.fields.inspdccValue__c.value;
            }
        }
    }
  
    handleInsuranceDecTree() {
        this.isEditEnable = true;
    }

    handleCancel () {
        this.isEditEnable = false;
        this.isToggleOnMatrix = false;
        this.isToggleOn = false;
    }
    
    handleToggleInsurenceOff () {
        this.isToggleOn = false;
        this.isToggleOnMatrix = false;
    }

    handelUrlClick (event) {
        let matricUrl = window.location.origin + '/'+ event.currentTarget.dataset.name;
        window.open(matricUrl, "_blank");
    }

    handleToggleInsurenceOn () {
        const insDataSet = this.template.querySelector('c-patient-access-case-insurance-decision');
        this.isRequired = false;

       if ((insDataSet.servicecategoriesvalue && insDataSet.plantypevalue && insDataSet.healthplanvalue && insDataSet.medicalgroupipavalue
            && insDataSet.doespatienthaveauthvalue && insDataSet.doespatienthaveauthvalueyesorno === 'Yes' && insDataSet.lineofbusinessvalue ) 
            || (insDataSet.servicecategoriesvalue && insDataSet.plantypevalue && insDataSet.healthplanvalue && insDataSet.medicalgroupipavalue
                 && insDataSet.lineofbusinessvalue)) {
         this.isRequired = false;

            getSchedulingGuidelines({
                planType : insDataSet.plantypevalue,
                lineOfBusiness : insDataSet.lineofbusinessvalue,
                healthPlan : insDataSet.healthplanvalue,
                medicalGroupIPA : insDataSet.medicalgroupipavalue,
                authrequired : insDataSet.doespatienthaveauthvalueyesorno,
                servicecategories : insDataSet.servicecategoriesvalue
            })
            .then(result => {
                    this.guidelinesTable = result;
                    this.isToggleOn = true;
                    this.isToggleOnMatrix = true;
                    this.inspdccValue = this.guidelinesTable.formPrimaryDeliveryofCareCenter;
                    if (this.dataSet.fields.Service_Category__c.value != insDataSet.servicecategoriesvalue || this.dataSet.fields.Plan_Type__c.value != insDataSet.plantypevalue ||
                        this.dataSet.fields.Health_Plan__c.value != insDataSet.healthplanvalue || this.dataSet.fields.Medical_Group_IPA__c.value != insDataSet.medicalgroupipavalue 
                        || this.dataSet.fields.Line_of_Business_Decision_Tree__c.value != insDataSet.lineofbusinessvalue){
                        window.setTimeout(()=> {
                            this.template.querySelector('c-patient-access-physician-decision-list').refreshInspdccValue();
                        },1000);
                    } 
                    const recordInput = {fields:{ 
                        Id : this.recordId,
                        Service_Category__c : insDataSet.servicecategoriesvalue,
                        Plan_Type__c : insDataSet.plantypevalue,
                        Health_Plan__c : insDataSet.healthplanvalue,
                        Medical_Group_IPA__c : insDataSet.medicalgroupipavalue,
                        Does_patient_have_auth_at_time_of_schedu__c : insDataSet.doespatienthaveauthvalueyesorno,
                        Auth__c : insDataSet.doespatienthaveauthvalue,
                        Line_of_Business_Decision_Tree__c : insDataSet.lineofbusinessvalue,
                        inspdccValue__c : this.inspdccValue
                    }};
                    updateRecord(recordInput);
                    const evt = new ShowToastEvent({
                        title: 'Insurance Data',
                        message: 'Insurance Picklist Values are stored',
                        variant: 'Success',
                    });
                    this.dispatchEvent(evt); 
            })
            .catch(error =>{
                console.log(' Errors ', error);
                this.errors = error;
            })
       } else {
           console.log('entred');
         this.isRequired = true;
       }

    }

    handlePhysicianData () {       
        const phyDataSet = this.template.querySelector('c-patient-access-physician-decision-list');
        var subGrpValue = '';
        if((phyDataSet.specialtyvalue != null || phyDataSet.specialtyvalue !='') && (phyDataSet.servicelinevalue != null || phyDataSet.servicelinevalue !='') 
         && (phyDataSet.physicianvalue != null || phyDataSet.physicianvalue !='') && (phyDataSet.locationvalue != null || phyDataSet.locationvalue !='')
         && (phyDataSet.departmentvalue != null || phyDataSet.departmentvalue !='')){
            searchPhysicianMatrices({
                locationVal : phyDataSet.locationvalue,
                department : phyDataSet.departmentvalue,
                serviceline : phyDataSet.servicelinevalue,
                specialty : phyDataSet.specialtyvalue,
                physician : phyDataSet.physicianvalue,
                caseId : this.recordId,
                inspdccs : this.inspdccValue
            })
            .then(result => {
                let recPhysicianMatrix = JSON.parse(result);
                //Null check fix by Sanjay 05/23/2022
                subGrpValue = recPhysicianMatrix.length ? recPhysicianMatrix[0].record.Subgroup_No__c : '';
                const recordInput = {fields:{ 
                    Id : this.recordId,
                    Specialty__c : phyDataSet.specialtyvalue,
                    Service_Line__c : phyDataSet.servicelinevalue,
                    Physician_Decision_Tree__c : phyDataSet.physicianvalue,
                    Location__c : phyDataSet.locationvalue,
                    Department__c : phyDataSet.departmentvalue,
                    Physician__c :  phyDataSet.physicianId,
                    Subgroup_Num__c : subGrpValue,
                    Diagnosis_Not_Listed__c: !!phyDataSet.getDiagnosisNotListedValue() //CHANGES BY SANJAY 05/23/2022
                }};
                updateRecord(recordInput);
                const evt = new ShowToastEvent({
                    title: 'Update Physician Data',
                    message: 'Physician Picklist Values are stored',
                    variant: 'Success',
                });
        this.dispatchEvent(evt); 
            })
            .catch(error => {
                console.log(' Errors ', error);
            })
         }

    }

    handleRefreshMatrix () {
        if (this.isToggleOnMatrix === true) {
            const insDataSet = this.template.querySelector('c-patient-access-case-insurance-decision');
            getSchedulingGuidelines({
                planType : insDataSet.plantypevalue,
                lineOfBusiness : insDataSet.lineofbusinessvalue,
                healthPlan : insDataSet.healthplanvalue,
                medicalGroupIPA : insDataSet.medicalgroupipavalue,
                authrequired : insDataSet.doespatienthaveauthvalueyesorno,
                servicecategories : insDataSet.servicecategoriesvalue
            }) .then(result => {
                    this.guidelinesTable = result;
                    this.isToggleOn = true;
                    this.isToggleOnMatrix = true;
                    this.inspdccValue = this.guidelinesTable.formPrimaryDeliveryofCareCenter;
                    window.setTimeout(()=> {
                         this.template.querySelector('c-patient-access-physician-decision-list').refreshInspdccValue();
                    },1000);
            })
            .catch(error =>{
                console.log(' Errors ', error);
                this.errors = error;
            })
        }
    }
}